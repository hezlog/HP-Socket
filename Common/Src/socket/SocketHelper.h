/*
 * Copyright: JessMA Open Source (ldcsaa@gmail.com)
 *
 * Version	: 3.2.1
 * Author	: Bruce Liang
 * Website	: http://www.jessma.org
 * Project	: https://github.com/ldcsaa
 * Blog		: http://www.cnblogs.com/ldcsaa
 * Wiki		: http://www.oschina.net/p/hp-socket
 * QQ Group	: 75375912
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#pragma once

#include <ws2tcpip.h>
#include <mswsock.h>
#include <malloc.h>

#include "SocketInterface.h"
#include"../WaitFor.h"

/************************************************************************
���ƣ�Windows Socket �����ʼ����
�������Զ����غ�ж�� Windows Socket ���
************************************************************************/
class CInitSocket
{
public:
	CInitSocket(LPWSADATA lpWSAData = nullptr, BYTE minorVersion = 2, BYTE majorVersion = 2)
	{
		LPWSADATA lpTemp = lpWSAData;
		if(!lpTemp)
			lpTemp	= (LPWSADATA)_alloca(sizeof(WSADATA));

		m_iResult	= ::WSAStartup(MAKEWORD(minorVersion, majorVersion), lpTemp);
	}

	~CInitSocket()
	{
		if(IsValid())
			::WSACleanup();
	}

	int		GetResult()	{return m_iResult;}
	BOOL	IsValid()	{return m_iResult == 0;}

private:
	int		m_iResult;
};

enum EnSocketCloseFlag
{
	SCF_NONE	= 0,
	SCF_CLOSE	= 1,
	SCF_ERROR	= 2
};

/* ���ݻ����������ṹ */
struct TBufferObjBase
{
	OVERLAPPED			ov;
	WSABUF				buff;
	EnSocketOperation	operation;
};

/* ���ݻ������ṹ */
struct TBufferObj : public TBufferObjBase
{
	SOCKET client;
};

/* UDP ���ݻ������ṹ */
struct TUdpBufferObj : public TBufferObjBase
{
	SOCKADDR_IN	remoteAddr;
};

/* ���ݻ������ṹ���� */
typedef deque<TBufferObj*>		TBufferObjPtrList;

/* Udp ���ݻ������ṹ���� */
typedef deque<TUdpBufferObj*>	TUdpBufferObjPtrList;

/* Socket �����������ṹ */
struct TSocketObjBase
{
	CONNID		connID;
	SOCKADDR_IN	remoteAddr;
	PVOID		extra;
	BOOL		valid;

	union
	{
		DWORD	freeTime;
		DWORD	connTime;
	};

	static BOOL IsExist(TSocketObjBase* pSocketObj)
		{return pSocketObj != nullptr;}

	static BOOL IsValid(TSocketObjBase* pSocketObj)
		{return IsExist(pSocketObj) && pSocketObj->valid == TRUE;}

	static void Invalid(TSocketObjBase* pSocketObj)
		{ASSERT(IsExist(pSocketObj)); pSocketObj->valid = FALSE;}

	void Reset(CONNID dwConnID)
	{
		connID	= dwConnID;
		valid	= TRUE;
		extra	= nullptr;
	}
};

/* ���ݻ������ṹ */
struct TSocketObj : public TSocketObjBase
{
	SOCKET		socket;
	CCriSec		crisec;

	void Reset(CONNID dwConnID, SOCKET soClient)
	{
		__super::Reset(dwConnID);
		socket = soClient;
	}
};

/* UDP ���ݻ������ṹ */
struct TUdpSocketObj : public TSocketObjBase
{
	volatile DWORD	detectFails;

	void Reset(CONNID dwConnID)
	{
		__super::Reset(dwConnID);
		detectFails = 0;
	}
};

/* ���ݻ������ṹ���� */
typedef deque<TSocketObj*>					TSocketObjPtrList;
/* ���ݻ������ṹ��ϣ�� */
typedef hash_map<CONNID, TSocketObj*>		TSocketObjPtrMap;
/* ���ݻ������ṹ��ϣ�������� */
typedef TSocketObjPtrMap::iterator			TSocketObjPtrMapI;
/* ���ݻ������ṹ��ϣ�� const ������ */
typedef TSocketObjPtrMap::const_iterator	TSocketObjPtrMapCI;

/* UDP ���ݻ������ṹ���� */
typedef deque<TUdpSocketObj*>				TUdpSocketObjPtrList;
/* UDP ���ݻ������ṹ��ϣ�� */
typedef hash_map<CONNID, TUdpSocketObj*>	TUdpSocketObjPtrMap;
/* UDP ���ݻ������ṹ��ϣ�������� */
typedef TUdpSocketObjPtrMap::iterator		TUdpSocketObjPtrMapI;
/* UDP ���ݻ������ṹ��ϣ�� const ������ */
typedef TUdpSocketObjPtrMap::const_iterator	TUdpSocketObjPtrMapCI;

/* SOCKADDR_IN �Ƚ��� */
template<size_t bk_size = 4, size_t min_bks = 8>
struct sockaddr_hash_func
{
	enum
	{
		bucket_size	= bk_size,
		min_buckets	= min_bks,
	};

	//HASH_MAP������
	size_t operator() (const SOCKADDR_IN* pA) const
	{
		return	((pA->sin_family << 16) | ntohs(pA->sin_port)) ^ pA->sin_addr.s_addr;
	}

	//�ȽϺ�����
	bool operator() (const SOCKADDR_IN* pA, const SOCKADDR_IN* pB) const
	{
		return memcmp(pA, pB, offsetof(SOCKADDR_IN, sin_zero)) < 0;
	}
};

/* ��ַ-���� ID ��ϣ�� */
typedef hash_map<SOCKADDR_IN*, CONNID, sockaddr_hash_func<>>	TSockAddrMap;
/* ��ַ-���� ID ��ϣ�������� */
typedef TSockAddrMap::iterator									TSockAddrMapI;
/* ��ַ-���� ID ��ϣ�� const ������ */
typedef TSockAddrMap::const_iterator							TSockAddrMapCI;

/*****************************************************************************************************/
/******************************************** ������������ ********************************************/
/*****************************************************************************************************/

/* ��ȡ���������ı� */
LPCTSTR GetSocketErrorDesc(EnSocketError enCode);
/* ����ַ����Ƿ���� IP ��ַ��ʽ */
BOOL IsIPAddress(LPCTSTR lpszAddress);
/* ͨ����������ȡ IP ��ַ */
BOOL GetIPAddress(LPCTSTR lpszHost, __out LPTSTR lpszIP, __inout int& iIPLenth);
/* ͨ����������ȡ���ŵ� IP ��ַ */
BOOL GetOptimalIPByHostName(LPCTSTR lpszHost, __out IN_ADDR& addr);
/* ��ȡ IN_ADDR �ṹ�� IP ��ַ */
BOOL IN_ADDR_2_IP(const IN_ADDR& addr, __out LPTSTR lpszAddress, __inout int& iAddressLen);
/* �� SOCKADDR_IN �ṹת��Ϊ��ַ���� */
BOOL sockaddr_IN_2_A(const SOCKADDR_IN& addr, __out ADDRESS_FAMILY& usFamily, __out LPTSTR lpszAddress, __inout int& iAddressLen, __out USHORT& usPort);
/* �ѵ�ַ����ת��Ϊ SOCKADDR_IN �ṹ */
BOOL sockaddr_A_2_IN(ADDRESS_FAMILY usFamily, LPCTSTR pszAddress, USHORT usPort, __out SOCKADDR_IN& addr);
/* ��ȡ Socket �ı��ػ�Զ�̵�ַ��Ϣ */
BOOL GetSocketAddress(SOCKET socket, __out LPTSTR lpszAddress, __inout int& iAddressLen, __out USHORT& usPort, BOOL bLocal = TRUE);
/* ��ȡ Socket �ı��ص�ַ��Ϣ */
BOOL GetSocketLocalAddress(SOCKET socket, __out LPTSTR lpszAddress, __inout int& iAddressLen, __out USHORT& usPort);
/* ��ȡ Socket ��Զ�̵�ַ��Ϣ */
BOOL GetSocketRemoteAddress(SOCKET socket, __out LPTSTR lpszAddress, __inout int& iAddressLen, __out USHORT& usPort);

/* ��ȡ Socket ��ĳ����չ������ָ�� */
PVOID GetExtensionFuncPtr					(SOCKET sock, GUID guid);
/* ��ȡ AcceptEx ��չ����ָ�� */
LPFN_ACCEPTEX Get_AcceptEx_FuncPtr			(SOCKET sock);
/* ��ȡ GetAcceptExSockaddrs ��չ����ָ�� */
LPFN_GETACCEPTEXSOCKADDRS Get_GetAcceptExSockaddrs_FuncPtr(SOCKET sock);
/* ��ȡ ConnectEx ��չ����ָ�� */
LPFN_CONNECTEX Get_ConnectEx_FuncPtr		(SOCKET sock);
/* ��ȡ TransmitFile ��չ����ָ�� */
LPFN_TRANSMITFILE Get_TransmitFile_FuncPtr	(SOCKET sock);
/* ��ȡ DisconnectEx ��չ����ָ�� */
LPFN_DISCONNECTEX Get_DisconnectEx_FuncPtr	(SOCKET sock);

/************************************************************************
���ƣ�setsockopt() ��������
�������򻯳��õ� setsockopt() ����
************************************************************************/

int SSO_UpdateAcceptContext	(SOCKET soClient, SOCKET soBind);
int SSO_UpdateConnectContext(SOCKET soClient, int iOption);
int SSO_NoDelay				(SOCKET sock, BOOL bNoDelay = TRUE);
int SSO_DontLinger			(SOCKET sock, BOOL bDont = TRUE);
int SSO_Linger				(SOCKET sock, USHORT l_onoff, USHORT l_linger);
int SSO_KeepAlive			(SOCKET sock, BOOL bKeepAlive = TRUE);
int SSO_KeepAliveVals		(SOCKET sock, u_long onoff, u_long time, u_long interval);
int SSO_RecvBuffSize		(SOCKET sock, int size);
int SSO_SendBuffSize		(SOCKET sock, int size);
int SSO_ReuseAddress		(SOCKET sock, BOOL bReuse = TRUE);
int SSO_UDP_ConnReset		(SOCKET sock, BOOL bNewBehavior = TRUE);

/************************************************************************
���ƣ�Socket ��������
������Socket ������װ����
************************************************************************/

/* ���� Connection ID */
CONNID GenerateConnectionID	();
/* �ر� Socket */
int ManualCloseSocket		(SOCKET sock, int iShutdownFlag = 0xFF, BOOL bGraceful = TRUE, BOOL bReuseAddress = FALSE);
/* Ͷ�� AccceptEx() */
int PostAccept				(LPFN_ACCEPTEX pfnAcceptEx, SOCKET soListen, SOCKET soClient, TBufferObj* pBufferObj);
/* Ͷ�� ConnectEx() */
int PostConnect				(LPFN_CONNECTEX pfnConnectEx, SOCKET soClient, SOCKADDR_IN& soAddrIN, TBufferObj* pBufferObj);
/* Ͷ�� WSASend() */
int PostSend				(TSocketObj* pSocketObj, TBufferObj* pBufferObj);
/* Ͷ�� WSARecv() */
int PostReceive				(TSocketObj* pSocketObj, TBufferObj* pBufferObj);
/* Ͷ�� WSASendTo() */
int PostSendTo				(SOCKET sock, TUdpBufferObj* pBufferObj);
/* Ͷ�� WSARecvFrom() */
int PostReceiveFrom			(SOCKET sock, TUdpBufferObj* pBufferObj);