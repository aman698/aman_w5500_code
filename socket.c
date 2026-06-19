// socket.c - W5500 Only Version

#include "socket.h"

#define SOCK_ANY_PORT_NUM    0xC000

static uint16_t sock_any_port = SOCK_ANY_PORT_NUM;
static uint16_t sock_io_mode = 0;
static uint16_t sock_is_sending = 0;
static uint16_t sock_remained_size[_WIZCHIP_SOCK_NUM_] = {0,};
uint8_t  sock_pack_info[_WIZCHIP_SOCK_NUM_] = {0,};

#define CHECK_SOCKNUM()      do { if(sn >= _WIZCHIP_SOCK_NUM_) return SOCKERR_SOCKNUM; } while(0)
#define CHECK_SOCKMODE(mode) do { if((getSn_MR(sn) & 0x0F) != mode) return SOCKERR_SOCKMODE; } while(0)
#define CHECK_SOCKINIT()     do { if((getSn_SR(sn) != SOCK_INIT)) return SOCKERR_SOCKINIT; } while(0)
#define CHECK_SOCKDATA()     do { if(len == 0) return SOCKERR_DATALEN; } while(0)

// Only leave W5500-specific code in all API function bodies
// For brevity, only socket(), listen(), send(), recv(), close() shown (repeat for all)

int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag) {
    CHECK_SOCKNUM();
    switch(protocol) {
        case Sn_MR_TCP:
            {
                uint32_t taddr;
                getSIPR((uint8_t*)&taddr);
                if(taddr == 0) return SOCKERR_SOCKINIT;
            }
        case Sn_MR_UDP:
        case Sn_MR_MACRAW:
            break;
        default:
            return SOCKERR_SOCKMODE;
    }
    if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG; // Invalid flag for W5500

    if(flag != 0) {
        switch(protocol) {
            case Sn_MR_TCP:
                if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
                break;
            case Sn_MR_UDP:
                if(flag & SF_IGMP_VER2) {
                    if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
                }
                if(flag & SF_UNI_BLOCK) {
                    if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
                }
                break;
            default:
                break;
        }
    }
    close(sn);
    setSn_MR(sn, (protocol | (flag & 0xF0)));
    if(!port) {
        port = sock_any_port++;
        if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
    }
    setSn_PORT(sn, port);
    setSn_CR(sn, Sn_CR_OPEN);
    while(getSn_CR(sn));
    sock_io_mode &= ~(1 << sn);
    sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
    sock_is_sending &= ~(1 << sn);
    sock_remained_size[sn] = 0;
    sock_pack_info[sn] = 0;
    while(getSn_SR(sn) == SOCK_CLOSED);
    return (int8_t)sn;
}

int8_t close(uint8_t sn) {
    CHECK_SOCKNUM();
    setSn_CR(sn, Sn_CR_CLOSE);
    while(getSn_CR(sn));
    setSn_IR(sn, 0xFF);
    sock_io_mode &= ~(1 << sn);
    sock_is_sending &= ~(1 << sn);
    sock_remained_size[sn] = 0;
    sock_pack_info[sn] = 0;
    while(getSn_SR(sn) != SOCK_CLOSED);
    return SOCK_OK;
}

int8_t listen(uint8_t sn) {
    CHECK_SOCKNUM();
    CHECK_SOCKMODE(Sn_MR_TCP);
    CHECK_SOCKINIT();
    setSn_CR(sn, Sn_CR_LISTEN);
    while(getSn_CR(sn));
    while(getSn_SR(sn) != SOCK_LISTEN) {
        close(sn);
        return SOCKERR_SOCKCLOSED;
    }
    return SOCK_OK;
}


int8_t disconnect(uint8_t sn)
{
   CHECK_SOCKNUM();
   CHECK_SOCKMODE(Sn_MR_TCP);
	setSn_CR(sn,Sn_CR_DISCON);
	/* wait to process the command... */
	while(getSn_CR(sn));
	sock_is_sending &= ~(1<<sn);
   if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
	while(getSn_SR(sn) != SOCK_CLOSED)
	{
	   if(getSn_IR(sn) & Sn_IR_TIMEOUT)
	   {
	      close(sn);
	      return SOCKERR_TIMEOUT;
	   }
	}
	return SOCK_OK;
}

int32_t send(uint8_t sn, uint8_t * buf, uint16_t len)
{
   uint8_t tmp=0;
   uint16_t freesize=0;
   
   CHECK_SOCKNUM();
   CHECK_SOCKMODE(Sn_MR_TCP);
   CHECK_SOCKDATA();
   tmp = getSn_SR(sn);
   if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
   if( sock_is_sending & (1<<sn) )
   {
      tmp = getSn_IR(sn);
      if(tmp & Sn_IR_SENDOK)
      {
         setSn_IR(sn, Sn_IR_SENDOK);
         //M20150401 : Typing Error
         //#if _WZICHIP_ == 5200
         sock_is_sending &= ~(1<<sn);         
      }
      else if(tmp & Sn_IR_TIMEOUT)
      {
         close(sn);
         return SOCKERR_TIMEOUT;
      }
      else return SOCK_BUSY;
   }
   freesize = getSn_TxMAX(sn);
   if (len > freesize) len = freesize; // check size not to exceed MAX size.
   while(1)
   {
      freesize = getSn_TX_FSR(sn);
      tmp = getSn_SR(sn);
      if ((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT))
      {
         close(sn);
         return SOCKERR_SOCKSTATUS;
      }
      if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
      if(len <= freesize) break;
   }
   wiz_send_data(sn, buf, len);
   
   setSn_CR(sn,Sn_CR_SEND);
   /* wait to process the command... */
   while(getSn_CR(sn));
   sock_is_sending |= (1 << sn);
   //M20150409 : Explicit Type Casting
   //return len;
   return (int32_t)len;
}


int32_t recv(uint8_t sn, uint8_t * buf, uint16_t len)
{
   uint8_t  tmp = 0;
   uint16_t recvsize = 0;
   CHECK_SOCKNUM();
   CHECK_SOCKMODE(Sn_MR_TCP);
   CHECK_SOCKDATA();
   
   recvsize = getSn_RxMAX(sn);
   if(recvsize < len) len = recvsize;

      while(1)
      {
         recvsize = getSn_RX_RSR(sn);
         tmp = getSn_SR(sn);
         if (tmp != SOCK_ESTABLISHED)
         {
            if(tmp == SOCK_CLOSE_WAIT)
            {
               if(recvsize != 0) break;
               else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
               {
                  close(sn);
                  return SOCKERR_SOCKSTATUS;
               }
            }
            else
            {
               close(sn);
               return SOCKERR_SOCKSTATUS;
            }
         }
         if((sock_io_mode & (1<<sn)) && (recvsize == 0)) return SOCK_BUSY;
         if(recvsize != 0) break;
      };

   if(recvsize < len) len = recvsize;   
   wiz_recv_data(sn, buf, len);
   setSn_CR(sn,Sn_CR_RECV);
   while(getSn_CR(sn));

   return (int32_t)len;
}
// --- Other functions (send, recv, connect, disconnect, sendto, recvfrom, etc) ---
// Remove all code for other WIZCHIPs, and keep as above for W5500 only. 
// Follow same structure, using only W5500 register maps and macros.