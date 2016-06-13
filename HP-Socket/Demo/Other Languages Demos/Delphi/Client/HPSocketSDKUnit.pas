//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  ������¥                  BUG����
//          ��Ի:
//                  д��¥��д�ּ䣬д�ּ������Ա��
//                  ������Աд�������ó��򻻾�Ǯ��
//                  ����ֻ���������������������ߣ�
//                  ��������ո��գ����������긴�ꡣ
//                  ��Ը�������Լ䣬��Ը�Ϲ��ϰ�ǰ��
//                  ���۱������Ȥ���������г���Ա��
//                  ����Ц��߯��񲣬��Ц�Լ���̫����
//                  ��������Ư���ã��ĸ���ó���Ա��
unit HPSocketSDKUnit;

interface

uses
  Windows, SysUtils,DateUtils,StrUtils;

const
  HPSocketDLL = 'HPSocket4C_U.dll';

type
{$Z4}
  SOCKET = Pointer;

  WSABUF = Record
    len: ULONG; { the length of the buffer }
    buf: PChar; { the pointer to the buffer }
  end { WSABUF };

  PWSABUF = ^WSABUF;
  LPWSABUF = PWSABUF;

  WSABUFArray = array of WSABUF;

  PInteger = ^Integer;
  PUShort = ^Word;
  { /************************************************************************
    ���ƣ����� ID ��������
    �������������� ID ����������
    ************************************************************************/ }
  HP_CONNID = DWORD;
  PHP_CONNID = ^HP_CONNID;
  HP_CONNIDArray = array of HP_CONNID; { TODO : ����������������ȡ��������id }
  { /************************************************************************
    ���ƣ����� Socket ����ָ�����ͱ���
    �������� Socket ����ָ�붨��Ϊ��ֱ�۵ı���
    ************************************************************************/ }
  HP_Object = longint;

  HP_Server = HP_Object;
  HP_Agent = HP_Object;
  HP_Client = HP_Object;
  HP_TcpServer = HP_Object;
  HP_HttpServer = HP_Object;
  HP_TcpAgent = HP_Object;
  HP_TcpClient = HP_Object;
  HP_PullSocket = HP_Object;
  HP_PullClient = HP_Object;
  HP_TcpPullServer = HP_Object;
  HP_TcpPullAgent = HP_Object;
  HP_TcpPullClient = HP_Object;
  HP_PackSocket = HP_Object;
  HP_PackClient = HP_Object;
  HP_TcpPackServer = HP_Object;
  HP_TcpPackAgent = HP_Object;
  HP_TcpPackClient = HP_Object;
  HP_UdpServer = HP_Object;
  HP_UdpClient = HP_Object;
  HP_UdpCast = HP_Object;

  HP_Listener = HP_Object;
  HP_ServerListener = HP_Object;
  HP_AgentListener = HP_Object;
  HP_ClientListener = HP_Object;
  HP_TcpServerListener = HP_Object;
  HP_HttpServerListener = HP_Object;
  HP_TcpAgentListener = HP_Object;
  HP_TcpClientListener = HP_Object;
  HP_PullSocketListener = HP_Object;
  HP_PullClientListener = HP_Object;
  HP_TcpPullServerListener = HP_Object;
  HP_TcpPullAgentListener = HP_Object;
  HP_TcpPullClientListener = HP_Object;
  HP_UdpServerListener = HP_Object;
  HP_UdpClientListener = HP_Object;
  HP_UdpCastListener = HP_Object;

  {******************************************** �����ࡢ�ӿ� ********************************************/}

  {TODO:/************************************************************************
    ���ƣ�ͨ���������״̬
    ������Ӧ�ó������ͨ��ͨ������� GetState() ������ȡ�����ǰ����״̬
    ************************************************************************ }
  En_HP_ServiceState = (
    HP_SS_STARTING = 0, // ��������
    HP_SS_STARTED = 1, // �Ѿ�����
    HP_SS_STOPING = 2, // ����ֹͣ
    HP_SS_STOPED = 3 // �Ѿ�ֹͣ
    );

  { TODO:************************************************************************
    ���ƣ�Socket ��������
    ������Ӧ�ó���� OnErrror() �¼���ͨ���ò�����ʶ�����ֲ������µĴ���
    ************************************************************************ }
  En_HP_SocketOperation = (
    HP_SO_UNKNOWN = 0, // Unknown
    HP_SO_ACCEPT = 1, // Acccept
    HP_SO_CONNECT = 2, // Connnect
    HP_SO_SEND = 3, // Send
    HP_SO_RECEIVE = 4, // Receive
    HP_SO_CLOSE		= 5 // Close
    );

  {TODO: ************************************************************************
    ���ƣ��¼�֪ͨ������
    �������¼�֪ͨ�ķ���ֵ����ͬ�ķ���ֵ��Ӱ��ͨ������ĺ�����Ϊ
    ************************************************************************ }
  En_HP_HandleResult = (
    HP_HR_OK = 0, // �ɹ�����
    HP_HR_IGNORE = 1, // ���Դ���
    HP_HR_ERROR = 2 // ������
    );

  { TODO:/************************************************************************
    ���ƣ�����ץȡ���
    ����������ץȡ�����ķ���ֵ
    ************************************************************************/ }
  En_HP_FetchResult = (
    HP_FR_OK = 0, // �ɹ�
    HP_FR_LENGTH_TOO_LONG = 1, // ץȡ���ȹ���
    HP_FR_DATA_NOT_FOUND = 2 // �Ҳ��� ConnID ��Ӧ������
    );

  { TODO:/************************************************************************
    ���ƣ����ݷ��Ͳ���
    ������Server ����� Agent ��������ݷ��Ͳ���

    * ���ģʽ��Ĭ�ϣ�	�������Ѷ�����Ͳ��������������һ���ͣ����Ӵ���Ч��
    * ��ȫģʽ			�������Ѷ�����Ͳ��������������һ���ͣ������ƴ����ٶȣ����⻺�������
    * ֱ��ģʽ			����ÿһ�����Ͳ�����ֱ��Ͷ�ݣ������ڸ��ز��ߵ�Ҫ��ʵʱ�Խϸߵĳ���

    ************************************************************************/ }
  En_HP_SendPolicy = (
    HP_SP_PACK = 0, // ���ģʽ��Ĭ�ϣ�
    HP_SP_SAFE = 1, // ��ȫģʽ
    HP_SP_DIRECT = 2 // ֱ��ģʽ
    );

  { TODO:************************************************************************
    ���ƣ������������
    ������Start() / Stop() ����ִ��ʧ��ʱ����ͨ�� GetLastError() ��ȡ�������
    ************************************************************************ }
  En_HP_SocketError = (
    HP_SE_OK = 0, // �ɹ�
    HP_SE_ILLEGAL_STATE = 1, // ��ǰ״̬���������
    HP_SE_INVALID_PARAM = 2, // �Ƿ�����
    HP_SE_SOCKET_CREATE = 3, // ���� SOCKET ʧ��
    HP_SE_SOCKET_BIND = 4, // �� SOCKET ʧ��
    HP_SE_SOCKET_PREPARE = 5, // ���� SOCKET ʧ��
    HP_SE_SOCKET_LISTEN = 6, // ���� SOCKET ʧ��
    HP_SE_CP_CREATE = 7, // ������ɶ˿�ʧ��
    HP_SE_WORKER_THREAD_CREATE = 8, // ���������߳�ʧ��
    HP_SE_DETECT_THREAD_CREATE = 9, // ��������߳�ʧ��
    HP_SE_SOCKE_ATTACH_TO_CP = 10, // ����ɶ˿�ʧ��
    HP_SE_CONNECT_SERVER = 11, // ���ӷ�����ʧ��
    HP_SE_NETWORK = 12, // �������
    HP_SE_DATA_PROC = 13, // ���ݴ������
    HP_SE_DATA_SEND = 14, // ���ݷ���ʧ��

    //***** SSL Socket ��չ����������� *****/
    HP_SE_SSL_ENV_NOT_READY = 101     // SSL ����δ����
    );

  {TODO:
    /************************************************************************
  ���ƣ�����ģʽ
  ������UDP ����Ĳ���ģʽ���鲥��㲥��
  ************************************************************************/}
  En_HP_CastMode = (
    HP_CM_MULTICAST = 0, // �鲥
    HP_CM_BROADCAST = 1 // �㲥
    );


   { /************** HPSocket4C.dll �ص����� **************/ }
  {TODO: /* Tcp����˻ص����� */ }
  HP_FN_Server_OnPrepareListen = function(soListen: Pointer): En_HP_HandleResult; stdcall;
  // ���Ϊ TCP ���ӣ�pClientΪ SOCKET ��������Ϊ UDP ���ӣ�pClientΪ SOCKADDR_IN ָ�룻
  HP_FN_Server_OnAccept = function(dwConnID: HP_CONNID; pClient: Pointer): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnHandShake = function(dwConnID: HP_CONNID): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnSend = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnReceive = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnPullReceive = function(dwConnID: HP_CONNID; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnClose = function(dwConnID: HP_CONNID; enOperation: En_HP_SocketOperation; iErrorCode: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Server_OnShutdown = function(): En_HP_HandleResult; stdcall;

  {TODO: /* Agent �ص����� */ }
  HP_FN_Agent_OnPrepareConnect = function(dwConnID: HP_CONNID; SOCKET: Pointer): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnConnect = function(dwConnID: HP_CONNID): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnHandShake = function(dwConnID: HP_CONNID): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnSend = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnReceive = function(dwConnID: HP_CONNID; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnPullReceive = function(dwConnID: HP_CONNID; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnClose = function(dwConnID: HP_CONNID; enOperation: En_HP_SocketOperation; iErrorCode: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Agent_OnShutdown = function(): En_HP_HandleResult; stdcall;

   {TODO: /* Client �ص����� */ }
  HP_FN_Client_OnPrepareConnect = function(pClient: HP_Client; SOCKET: Pointer): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnConnect = function(pClient: HP_Client): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnHandShake = function(pClient: HP_Client): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnSend = function(pClient: HP_Client; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnReceive = function(pClient: HP_Client; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnPullReceive = function(pClient: HP_Client; iLength: Integer): En_HP_HandleResult; stdcall;
  HP_FN_Client_OnClose = function(pClient: HP_Client; enOperation: En_HP_SocketOperation; iLength: Integer): En_HP_HandleResult; stdcall;

  { /****************************************************/
    /************** HPSocket4C.dll �������� **************/ }
  {TODO: ���� HP_TcpServer ���� }
function Create_HP_TcpServer(pListener: HP_TcpServerListener): HP_TcpServer; stdcall; external HPSocketDLL;
  {TODO: ���� HP_HttpServer ���� }
function Create_HP_HttpServer(pListener: HP_HttpServerListener): HP_HttpServer; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpAgent ���� }
function Create_HP_TcpAgent(pListener: HP_TcpAgentListener): HP_TcpAgent; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpClient ���� }
function Create_HP_TcpClient(pListener: HP_TcpClientListener): HP_TcpClient; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullServer ���� }
function Create_HP_TcpPullServer(pListener: HP_TcpPullServerListener): HP_TcpPullServer; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullAgent ���� }
function Create_HP_TcpPullAgent(pListener: HP_TcpPullAgentListener): HP_TcpPullAgent; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullClient ����}
function Create_HP_TcpPullClient(pListener: HP_TcpPullClientListener): HP_TcpPullClient; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackServer ���� }
function Create_HP_TcpPackServer(pListener: HP_TcpServerListener): HP_TcpPackServer; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackAgent ����  }
function Create_HP_TcpPackAgent(pListener: HP_TcpAgentListener): HP_TcpPackAgent; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackClient ����}
function Create_HP_TcpPackClient(pListener: HP_TcpClientListener): HP_TcpPackClient; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpServer ����  }
function Create_HP_UdpServer(pListener: HP_UdpServerListener): HP_UdpServer; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpClient ���� }
function Create_HP_UdpClient(pListener: HP_UdpClientListener): HP_UdpClient; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpCast ���� }
function Create_HP_UdpCast(pListener: HP_UdpCastListener): HP_UdpCast; stdcall; external HPSocketDLL;

  {TODO: ���� HP_TcpServer ����  }
procedure Destroy_HP_TcpServer(pServer: HP_TcpServer); stdcall; external HPSocketDLL;
  {TODO: ���� HP_HttpServer ����  }
procedure Destroy_HP_HttpServer(pServer: HP_HttpServer); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpAgent ����  }
procedure Destroy_HP_TcpAgent(pAgent: HP_TcpAgent); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpClient ����  }
procedure Destroy_HP_TcpClient(pClient: HP_TcpClient); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullServer ����  }
procedure Destroy_HP_TcpPullServer(pServer: HP_TcpPullServer); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullAgent ����   }
procedure Destroy_HP_TcpPullAgent(pAgent: HP_TcpPullAgent); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullClient ����   }
procedure Destroy_HP_TcpPullClient(pClient: HP_TcpPullClient); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackServer ���� }
procedure Destroy_HP_TcpPackServer(pServer: HP_TcpPackServer); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackAgent ����  }
procedure Destroy_HP_TcpPackAgent(pAgent: HP_TcpPackAgent); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPackClient ���� }
procedure Destroy_HP_TcpPackClient(pClient: HP_TcpPackClient); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpServer ����    }
procedure Destroy_HP_UdpServer(pServer: HP_UdpServer); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpClient ����    }
procedure Destroy_HP_UdpClient(pClient: HP_UdpClient); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpCast ����    }
procedure Destroy_HP_UdpCast(pCast: HP_UdpCast); stdcall; external HPSocketDLL;

  {TODO: ���� HP_TcpServerListener and HP_TcpPackServerListener ����  }
function Create_HP_TcpServerListener(): HP_TcpServerListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_HttpServerListener ����  }
function Create_HP_HttpServerListener(): HP_HttpServerListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpAgentListener ����   }
function Create_HP_TcpAgentListener(): HP_TcpAgentListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpClientListener ����   }
function Create_HP_TcpClientListener(): HP_TcpClientListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullServerListener ���� }
function Create_HP_TcpPullServerListener(): HP_TcpPullServerListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullAgentListener ����  }
function Create_HP_TcpPullAgentListener(): HP_TcpPullAgentListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullClientListener ����   }
function Create_HP_TcpPullClientListener(): HP_TcpPullClientListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpServerListener ����     }
function Create_HP_UdpServerListener(): HP_UdpServerListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpClientListener ����   }
function Create_HP_UdpClientListener(): HP_UdpClientListener; stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpCastListener ����      }
function Create_HP_UdpCastListener(): HP_UdpCastListener; stdcall; external HPSocketDLL;

  {TODO: ���� HP_TcpServerListener and HP_TcpPackServerListener���� }
procedure Destroy_HP_TcpServerListener(pListener: HP_TcpServerListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_HttpServerListener ���� }
procedure Destroy_HP_HttpServerListener(pListener: HP_HttpServerListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpAgentListener ���� }
procedure Destroy_HP_TcpAgentListener(pListener: HP_TcpAgentListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpClientListener ����  }
procedure Destroy_HP_TcpClientListener(pListener: HP_TcpClientListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullServerListener ����  }
procedure Destroy_HP_TcpPullServerListener(pListener: HP_TcpPullServerListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullAgentListener ����  }
procedure Destroy_HP_TcpPullAgentListener(pListener: HP_TcpPullAgentListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_TcpPullClientListener ����  }
procedure Destroy_HP_TcpPullClientListener(pListener: HP_TcpPullClientListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpServerListener ����    }
procedure Destroy_HP_UdpServerListener(pListener: HP_UdpServerListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpClientListener ����   }
procedure Destroy_HP_UdpClientListener(pListener: HP_UdpClientListener); stdcall; external HPSocketDLL;
  {TODO: ���� HP_UdpCastListener ����    }
procedure Destroy_HP_UdpCastListener(pListener: HP_UdpCastListener); stdcall; external HPSocketDLL;

{TODO: ***************************** Server �ص��������÷��� ***************************** }
procedure HP_Set_FN_Server_OnPrepareListen(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnPrepareListen); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnAccept(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnAccept); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnHandShake(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnHandShake); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnSend(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnSend); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnReceive(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnPullReceive(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnClose(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnClose); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Server_OnShutdown(pListener: HP_TcpServerListener; fn: HP_FN_Server_OnShutdown); stdcall; external HPSocketDLL;



{TODO:****************************** Agent �ص��������÷��� ***************************** }
procedure HP_Set_FN_Agent_OnPrepareConnect(pListener: HP_AgentListener; fn: HP_FN_Agent_OnPrepareConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnConnect(pListener: HP_AgentListener; fn: HP_FN_Agent_OnConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnHandShake(pListener: HP_AgentListener; fn: HP_FN_Agent_OnHandShake); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnSend(pListener: HP_AgentListener; fn: HP_FN_Agent_OnSend); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnReceive(pListener: HP_AgentListener; fn: HP_FN_Agent_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnPullReceive(pListener: HP_AgentListener; fn: HP_FN_Agent_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnClose(pListener: HP_AgentListener; fn: HP_FN_Agent_OnClose); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Agent_OnAgentShutdown(pListener: HP_AgentListener; fn: HP_FN_Agent_OnShutdown); stdcall; external HPSocketDLL;

{TODO:***************************** Client �ص��������÷��� ***************************** }
procedure HP_Set_FN_Client_OnPrepareConnect(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnPrepareConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnConnect(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnConnect); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnHandShake(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnHandShake); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnSend(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnSend); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnReceive(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnPullReceive(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnPullReceive); stdcall; external HPSocketDLL;
procedure HP_Set_FN_Client_OnClose(pListener: HP_TcpClientListener; fn: HP_FN_Client_OnClose); stdcall; external HPSocketDLL;

{ /***************************** Server �������� *****************************/ }
{ TODO:
  * ���ƣ�����ͨ�����
  * ���������������ͨ�������������ɺ�ɿ�ʼ���տͻ������Ӳ��շ�����
  *
  * ������		pszBindAddress	-- ������ַ
  *		      	usPort			-- �����˿�
  * ����ֵ��	TRUE	-- �ɹ�
  *			      FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ������� }
function HP_Server_Start(pServer: HP_Server; pszBindAddress: WideString; usPort: Word): BOOL; stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��ر�ͨ�����
  * �������رշ����ͨ��������ر���ɺ�Ͽ����пͻ������Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��  TRUE	-- �ɹ�
  *			      FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ������� }
function HP_Server_Stop(pServer: HP_Server): BOOL; stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ���������
  * �������û�ͨ���÷�����ָ���ͻ��˷�������
  *
  * ������dwConnID	-- ���� ID
  *			  pBuffer		-- �������ݻ�����
  *		  	iLength		-- �������ݳ���
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�� }
   { Private declarations }

function HP_Server_Send(pServer: HP_Server; dwConnID: HP_CONNID; const pBuffer: Pointer; iLength: Integer): BOOL;
stdcall; external HPSocketDLL;


{ TODO:
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������dwConnID	-- ���� ID
  *		  	pBuffer		-- ���ͻ�����
  *			  iLength		-- ���ͻ���������
  *			  iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows ������� }
function HP_Server_SendPart(pServer: HP_Server; dwConnID: HP_CONNID; const pBuffer: Pointer; iLength: Integer; iOffset: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ����Ͷ�������
  * ��������ָ�����ӷ��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������	dwConnID	-- ���� ID
  *			    pBuffers	-- ���ͻ���������
  *			    iCount		-- ���ͻ�������Ŀ
  * ����ֵ��  TRUE	-- �ɹ�
  *		    	  FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows ������� }
function HP_Server_SendPackets(pServer: HP_Server; dwConnID: HP_CONNID; const pBuffers: WSABUFArray; iCount: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��Ͽ�����
  * �������Ͽ���ĳ���ͻ��˵�����
  *
  * ������	dwConnID	-- ���� ID
  *		    	bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�� }
function HP_Server_Disconnect(pServer: HP_Server; dwConnID: HP_CONNID; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��Ͽ���ʱ����
  * �������Ͽ�����ָ��ʱ��������
  *
  * ������  dwPeriod	-- ʱ�������룩
  *		    	bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�� }
function HP_Server_DisconnectLongConnections(pServer: HP_Server; dwPeriod: LongWord; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{  TODO:
  * ���ƣ��Ͽ���Ĭ����
  * �������Ͽ�����ָ��ʱ���ľ�Ĭ����
  *
  * ������dwPeriod	-- ʱ�������룩
  *		  	bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�� }
function HP_Server_DisconnectSilenceConnections(pServer: HP_Server; dwPeriod: LongWord; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{***************************** Server ���Է��ʷ��� *****************************/ }
{ TODO:
  * ���ƣ��������ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������  dwConnID	-- ���� ID
  *		    	pv			-- ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID�� }
function HP_Server_SetConnectionExtra(pServer: HP_Server; dwConnID: HP_CONNID; pExtra: Pointer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ���ȡ���ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������ dwConnID	-- ���� ID
  *			   ppv			-- ����ָ��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID�� }
function HP_Server_GetConnectionExtra(pServer: HP_Server; dwConnID: HP_CONNID; ppExtra: Pointer): BOOL;
stdcall; external HPSocketDLL;

{ TODO: ���ͨ������Ƿ������� */ }
function HP_Server_HasStarted(pServer: HP_Server): BOOL; stdcall; external HPSocketDLL;
{ TODO: �鿴ͨ�������ǰ״̬ */ }
function HP_Server_GetState(pServer: HP_Server): En_HP_ServiceState; stdcall; external HPSocketDLL;
{ TODO: ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Server_GetLastError(pServer: HP_Server): En_HP_SocketError; stdcall; external HPSocketDLL;
{ TODO: ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Server_GetLastErrorDesc(pServer: HP_Server): PWideChar; stdcall; external HPSocketDLL;
{ TODO: ��ȡ������δ�������ݵĳ��� */ }
function HP_Server_GetPendingDataLength(pServer: HP_Server; dwConnID: HP_CONNID; piPending: PInteger): BOOL; stdcall; external HPSocketDLL;
{ TODO: ��ȡ�ͻ��������� */ }
function HP_Server_GetConnectionCount(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ�������ӵ� CONNID */ }
function HP_Server_GetAllConnectionIDs(pServer: HP_Server; pIDs: HP_CONNIDArray; pdwCount: PLongint): BOOL; stdcall; external HPSocketDLL;
{ TODO: ��ȡĳ���ͻ�������ʱ�������룩 */ }
function HP_Server_GetConnectPeriod(pServer: HP_Server; dwConnID: HP_CONNID; pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{ TODO: ��ȡĳ�����Ӿ�Ĭʱ�䣨���룩 */  }
function HP_Server_GetSilencePeriod(pServer: HP_Server; dwConnID: HP_CONNID; pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{ TODO: ��ȡ���� Socket �ĵ�ַ��Ϣ */ }
function HP_Server_GetListenAddress(pServer: HP_Server; lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall; external HPSocketDLL;
{ TODO: ��ȡĳ�����ӵ�Զ�̵�ַ��Ϣ */ }
function HP_Server_GetRemoteAddress(pServer: HP_Server; dwConnID: HP_CONNID; lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall; external HPSocketDLL;

{ TODO: �������ݷ��Ͳ��� */ }
procedure HP_Server_SetSendPolicy(pServer: HP_Server; enSendPolicy: En_HP_SendPolicy); stdcall; external HPSocketDLL;
{ TODO: ���� Socket �����������ʱ�䣨���룬�������ڼ�� Socket ��������ܱ���ȡʹ�ã� */ }
procedure HP_Server_SetFreeSocketObjLockTime(pServer: HP_Server; dwFreeSocketObjLockTime: LongInt); stdcall; external HPSocketDLL;
{ TODO: ���� Socket ����ش�С��ͨ������Ϊƽ���������������� 1/3 - 1/2�� */ }
procedure HP_Server_SetFreeSocketObjPool(pServer: HP_Server; dwFreeSocketObjPool: LongInt); stdcall; external HPSocketDLL;
{ TODO: �����ڴ�黺��ش�С��ͨ������Ϊ Socket ����ش�С�� 2 - 3 ���� */ }
procedure HP_Server_SetFreeBufferObjPool(pServer: HP_Server; dwFreeBufferObjPool: LongInt); stdcall; external HPSocketDLL;
{ TODO: ���� Socket ����ػ��շ�ֵ��ͨ������Ϊ Socket ����ش�С�� 3 ���� */ }
procedure HP_Server_SetFreeSocketObjHold(pServer: HP_Server; dwFreeSocketObjHold: LongInt); stdcall; external HPSocketDLL;
{ TODO: �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Server_SetFreeBufferObjHold(pServer: HP_Server; dwFreeBufferObjHold: LongInt); stdcall; external HPSocketDLL;
{ TODO: ���ù����߳�������ͨ������Ϊ 2 * CPU + 2�� */ }
procedure HP_Server_SetWorkerThreadCount(pServer: HP_Server; dwWorkerThreadCount: LongInt); stdcall; external HPSocketDLL;
{ TODO: �����Ƿ��Ǿ�Ĭʱ�䣨����Ϊ TRUE ʱ DisconnectSilenceConnections() �� GetSilencePeriod() ����Ч��Ĭ�ϣ�FALSE�� */ }
procedure HP_Server_SetMarkSilence(pServer: HP_Server; bMarkSilence: BOOL); stdcall; external HPSocketDLL;

{ TODO: ��ȡ���ݷ��Ͳ��� */ }
function HP_Server_GetSendPolicy(pServer: HP_Server): En_HP_SendPolicy; stdcall; external HPSocketDLL;
{ TODO: ��ȡ Socket �����������ʱ�� */ }
function HP_Server_GetFreeSocketObjLockTime(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ Socket ����ش�С */ }
function HP_Server_GetFreeSocketObjPool(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ�ڴ�黺��ش�С */ }
function HP_Server_GetFreeBufferObjPool(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ Socket ����ػ��շ�ֵ */ }
function HP_Server_GetFreeSocketObjHold(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Server_GetFreeBufferObjHold(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ�����߳����� */ }
function HP_Server_GetWorkerThreadCount(pServer: HP_Server): LongInt; stdcall; external HPSocketDLL;
{ TODO: ����Ƿ��Ǿ�Ĭʱ�� */ }
function HP_Server_IsMarkSilence(pServer: HP_Server): BOOL; stdcall; external HPSocketDLL;

{ /******************************* TCP Server �������� *******************************/ }
{ TODO:
  * ���ƣ�����С�ļ�
  * ��������ָ�����ӷ��� 4096 KB ���µ�С�ļ�
  *
  * ������		dwConnID		-- ���� ID
  *			lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpServer_SendSmallFile(pServer: HP_Server; dwConnID: HP_CONNID;
  lpszFileName: PWideChar; const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL;
stdcall; external HPSocketDLL;

{ /***************************** TCP Server ���Է��ʷ��� *****************************/ }

{ TODO: ���ü��� Socket �ĵȺ���д�С�����ݲ������������������ã� */ }
procedure HP_TcpServer_SetSocketListenQueue(pServer: HP_TcpServer; dwSocketListenQueue: LongInt); stdcall; external HPSocketDLL;
{ TODO: ���� Accept ԤͶ�����������ݸ��ص������ã�Accept ԤͶ������Խ����֧�ֵĲ�����������Խ�ࣩ */ }
procedure HP_TcpServer_SetAcceptSocketCount(pServer: HP_TcpServer; dwAcceptSocketCount: LongInt); stdcall; external HPSocketDLL;
{ TODO: ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ 1024 �ı����� */ }
procedure HP_TcpServer_SetSocketBufferSize(pServer: HP_TcpServer; dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ TODO: ������������������룬0 �򲻷����������� */ }
procedure HP_TcpServer_SetKeepAliveTime(pServer: HP_TcpServer; dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ TODO: ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpServer_SetKeepAliveInterval(pServer: HP_TcpServer; dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ TODO: ��ȡ Accept ԤͶ������ */ }
function HP_TcpServer_GetAcceptSocketCount(pServer: HP_TcpServer): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡͨ�����ݻ�������С */ }
function HP_TcpServer_GetSocketBufferSize(pServer: HP_TcpServer): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ���� Socket �ĵȺ���д�С */ }
function HP_TcpServer_GetSocketListenQueue(pServer: HP_TcpServer): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ���������� */ }
function HP_TcpServer_GetKeepAliveTime(pServer: HP_TcpServer): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ��������� */ }
function HP_TcpServer_GetKeepAliveInterval(pServer: HP_TcpServer): LongInt; stdcall; external HPSocketDLL;

{ /***************************** UDP Server ���Է��ʷ��� *****************************/ }

{ TODO: �������ݱ�����󳤶ȣ������ھ����������²����� 1472 �ֽڣ��ڹ����������²����� 548 �ֽڣ� */ }
procedure HP_UdpServer_SetMaxDatagramSize(pServer: HP_UdpServer; dwMaxDatagramSize: LongInt); stdcall; external HPSocketDLL;
{ TODO: ��ȡ���ݱ�����󳤶� */ }
function HP_UdpServer_GetMaxDatagramSize(pServer: HP_UdpServer): LongInt; stdcall; external HPSocketDLL;

{ TODO: ���� Receive ԤͶ�����������ݸ��ص������ã�Receive ԤͶ������Խ���򶪰�����ԽС�� */ }
procedure HP_UdpServer_SetPostReceiveCount(pServer: HP_UdpServer; dwPostReceiveCount: LongInt); stdcall; external HPSocketDLL;
{ TODO: ��ȡ Receive ԤͶ������ */ }
function HP_UdpServer_GetPostReceiveCount(pServer: HP_UdpServer): LongInt; stdcall; external HPSocketDLL;

{ TODO: ���ü������Դ�����0 �򲻷��ͼ�������������������Դ�������Ϊ�Ѷ��ߣ� */ }
procedure HP_UdpServer_SetDetectAttempts(pServer: HP_UdpServer; dwDetectAttempts: LongInt); stdcall; external HPSocketDLL;
{ TODO: ���ü������ͼ�����룬0 �����ͼ����� */ }
procedure HP_UdpServer_SetDetectInterval(pServer: HP_UdpServer; dwDetectInterval: LongInt); stdcall; external HPSocketDLL;
{ TODO: ��ȡ���������� */ }
function HP_UdpServer_GetDetectAttempts(pServer: HP_UdpServer): LongInt; stdcall; external HPSocketDLL;
{ TODO: ��ȡ��������� */ }
function HP_UdpServer_GetDetectInterval(pServer: HP_UdpServer): LongInt; stdcall; external HPSocketDLL;

{ ***************************** Agent �������� ***************************** }

{ TODO:
  * ���ƣ�����ͨ�����
  * ����������ͨ�Ŵ��������������ɺ�ɿ�ʼ����Զ�̷�����
  *
  * ������	pszBindAddress	-- ������ַ
  *			    bAsyncConnect	-- �Ƿ�����첽 Connect
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Agent_Start(pAgent: HP_Agent; pszBindAddress: PWideChar; bAsyncConnect: BOOL): BOOL; stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��ر�ͨ�����
  * �������ر�ͨ��������ر���ɺ�Ͽ��������Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Agent_Stop(pAgent: HP_Agent): BOOL; stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ����ӷ�����
  * ���������ӷ����������ӳɹ��� IAgentListener ����յ� OnConnect() �¼�
  *
  * ������		pszRemoteAddress	-- ����˵�ַ
  *			usPort				-- ����˶˿�
  *			pdwConnID			-- ���� ID��Ĭ�ϣ�nullptr������ȡ���� ID��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ������ SYS_GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_Connect(pAgent: HP_Agent; pszRemoteAddress: PWideChar; usPort: Word; pdwConnID: PHP_CONNID): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_Send(pAgent: HP_Agent; dwConnID: HP_CONNID; const pBuffer: Pointer; iLength: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ���������
  * ��������ָ�����ӷ�������
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  *			iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_SendPart(pAgent: HP_Agent; dwConnID: HP_CONNID; const pBuffer: Pointer; iLength: Integer; iOffset: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ����Ͷ�������
  * ��������ָ�����ӷ��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffers	-- ���ͻ���������
  *			iCount		-- ���ͻ�������Ŀ
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Agent_SendPackets(pAgent: HP_Agent; dwConnID: HP_CONNID; const pBuffers: WSABUFArray; iCount: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��Ͽ�����
  * �������Ͽ�ĳ������
  *
  * ������		dwConnID	-- ���� ID
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Agent_Disconnect(pAgent: HP_Agent; dwConnID: HP_CONNID; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��Ͽ���ʱ����
  * �������Ͽ�����ָ��ʱ��������
  *
  * ������		dwPeriod	-- ʱ�������룩
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Agent_DisconnectLongConnections(pAgent: HP_Agent; dwPeriod: LongInt; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{ TODO:
  * ���ƣ��Ͽ���Ĭ����
  * �������Ͽ�����ָ��ʱ���ľ�Ĭ����
  *
  * ������		dwPeriod	-- ʱ�������룩
  *			bForce		-- �Ƿ�ǿ�ƶϿ�����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ��
  */ }
function HP_Agent_DisconnectSilenceConnections(pAgent: HP_Agent; dwPeriod: LongInt; bForce: BOOL): BOOL;
stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Agent ���Է��ʷ��� *****************************/ }

{ TODO
  * ���ƣ��������ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			pv			-- ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Agent_SetConnectionExtra(pAgent: HP_Agent; dwConnID: HP_CONNID; pExtra: Pointer): BOOL;
stdcall; external HPSocketDLL;

{ TODO
  * ���ƣ���ȡ���ӵĸ�������
  * �������Ƿ�Ϊ���Ӱ󶨸������ݻ��߰�ʲô�������ݣ�����Ӧ�ó���ֻ�����
  *
  * ������		dwConnID	-- ���� ID
  *			ppv			-- ����ָ��
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���Ч������ ID��
  */ }
function HP_Agent_GetConnectionExtra(pAgent: HP_Agent; dwConnID: HP_CONNID;
  ppExtra: Pointer): BOOL; stdcall; external HPSocketDLL;

{TODO ���ͨ������Ƿ������� */ }
function HP_Agent_HasStarted(pAgent: HP_Agent): BOOL; stdcall; external HPSocketDLL;
{TODO �鿴ͨ�������ǰ״̬ */ }
function HP_Agent_GetState(pAgent: HP_Agent): En_HP_ServiceState; stdcall; external HPSocketDLL;
{TODO ��ȡ������ */ }
function HP_Agent_GetConnectionCount(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ�������ӵ� CONNID */ }
function HP_Agent_GetAllConnectionIDs(pAgent: HP_Agent; pIDs: HP_CONNIDArray; pdwCount: PLongint): BOOL; stdcall; external HPSocketDLL;
{TODO ��ȡĳ������ʱ�������룩 */ }
function HP_Agent_GetConnectPeriod(pAgent: HP_Agent; dwConnID: HP_CONNID; pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{TODO ��ȡĳ�����Ӿ�Ĭʱ�䣨���룩 */ }
function HP_Agent_GetSilencePeriod(pAgent: HP_Agent; dwConnID: HP_CONNID; pdwPeriod: PLongint): BOOL; stdcall; external HPSocketDLL;
{TODO ��ȡĳ�����ӵı��ص�ַ��Ϣ */ }
function HP_Agent_GetLocalAddress(pAgent: HP_Agent; dwConnID: HP_CONNID; lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall; external HPSocketDLL;
{TODO ��ȡĳ�����ӵ�Զ�̵�ַ��Ϣ */ }
function HP_Agent_GetRemoteAddress(pAgent: HP_Agent; dwConnID: HP_CONNID; lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL; stdcall; external HPSocketDLL;
{TODO ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Agent_GetLastError(pAgent: HP_Agent): En_HP_SocketError; stdcall; external HPSocketDLL;
{TODO ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Agent_GetLastErrorDesc(pAgent: HP_Agent): PWideChar; stdcall; external HPSocketDLL;
{TODO ��ȡ������δ�������ݵĳ��� */ }
function HP_Agent_GetPendingDataLength(pAgent: HP_Agent; dwConnID: HP_CONNID; piPending: PInteger): BOOL; stdcall; external HPSocketDLL;

{TODO �������ݷ��Ͳ��� */ }
procedure HP_Agent_SetSendPolicy(pAgent: HP_Agent; enSendPolicy: En_HP_SendPolicy); stdcall; external HPSocketDLL;
{TODO ���� Socket �����������ʱ�䣨���룬�������ڼ�� Socket ��������ܱ���ȡʹ�ã� */ }
procedure HP_Agent_SetFreeSocketObjLockTime(pAgent: HP_Agent; dwFreeSocketObjLockTime: LongInt); stdcall; external HPSocketDLL;
{TODO ���� Socket ����ش�С��ͨ������Ϊƽ���������������� 1/3 - 1/2�� */ }
procedure HP_Agent_SetFreeSocketObjPool(pAgent: HP_Agent; dwFreeSocketObjPool: LongInt); stdcall; external HPSocketDLL;
{TODO �����ڴ�黺��ش�С��ͨ������Ϊ Socket ����ش�С�� 2 - 3 ���� */ }
procedure HP_Agent_SetFreeBufferObjPool(pAgent: HP_Agent; dwFreeBufferObjPool: LongInt); stdcall; external HPSocketDLL;
{TODO ���� Socket ����ػ��շ�ֵ��ͨ������Ϊ Socket ����ش�С�� 3 ���� */ }
procedure HP_Agent_SetFreeSocketObjHold(pAgent: HP_Agent; dwFreeSocketObjHold: LongInt); stdcall; external HPSocketDLL;
{TODO �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Agent_SetFreeBufferObjHold(pAgent: HP_Agent; dwFreeBufferObjHold: LongInt); stdcall; external HPSocketDLL;
{TODO ���ù����߳�������ͨ������Ϊ 2 * CPU + 2�� */ }
procedure HP_Agent_SetWorkerThreadCount(pAgent: HP_Agent; dwWorkerThreadCount: LongInt); stdcall; external HPSocketDLL;
{TODO �����Ƿ��Ǿ�Ĭʱ�䣨����Ϊ TRUE ʱ DisconnectSilenceConnections() �� GetSilencePeriod() ����Ч��Ĭ�ϣ�FALSE�� */ }
procedure HP_Agent_SetMarkSilence(pAgent: HP_Agent; bMarkSilence: BOOL); stdcall; external HPSocketDLL;

{TODO ��ȡ���ݷ��Ͳ��� */ }
function HP_Agent_GetSendPolicy(pAgent: HP_Agent): En_HP_SendPolicy; stdcall; external HPSocketDLL;
{TODO ��ȡ Socket �����������ʱ�� */ }
function HP_Agent_GetFreeSocketObjLockTime(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ��ȡ Socket ����ش�С */ }
function HP_Agent_GetFreeSocketObjPool(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ��ȡ�ڴ�黺��ش�С */ }
function HP_Agent_GetFreeBufferObjPool(HpAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ��ȡ Socket ����ػ��շ�ֵ */ }
function HP_Agent_GetFreeSocketObjHold(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Agent_GetFreeBufferObjHold(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ��ȡ�����߳����� */ }
function HP_Agent_GetWorkerThreadCount(pAgent: HP_Agent): LongInt; stdcall; external HPSocketDLL;
{TODO ����Ƿ��Ǿ�Ĭʱ�� */ }
function HP_Agent_IsMarkSilence(pAgent: HP_Agent): BOOL; stdcall; external HPSocketDLL;

{ ******************************* TCP Agent �������� ******************************* }

{TODO
  * ���ƣ�����С�ļ�
  * ��������ָ�����ӷ��� 4096 KB ���µ�С�ļ�
  *
  * ������		dwConnID		-- ���� ID
  *			lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpAgent_SendSmallFile(pAgent: HP_Agent; dwConnID: HP_CONNID; lpszFileName: PWideChar; const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL;
stdcall; external HPSocketDLL;

{ ***************************** TCP Agent ���Է��ʷ��� *****************************/ }

{ TODO �����Ƿ����õ�ַ���û��ƣ�Ĭ�ϣ������ã� */ }
procedure HP_TcpAgent_SetReuseAddress(pAgent: HP_TcpAgent; bReuseAddress: BOOL); stdcall; external HPSocketDLL;
{ TODO ����Ƿ����õ�ַ���û��� */ }
function HP_TcpAgent_IsReuseAddress(pAgent: HP_TcpAgent): BOOL; stdcall; external HPSocketDLL;

{ TODO ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ 1024 �ı����� */ }
procedure HP_TcpAgent_SetSocketBufferSize(pAgent: HP_TcpAgent; dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ TODO ������������������룬0 �򲻷����������� */ }
procedure HP_TcpAgent_SetKeepAliveTime(pAgent: HP_TcpAgent; dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ TODO ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpAgent_SetKeepAliveInterval(pAgent: HP_TcpAgent; dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ TODO ��ȡͨ�����ݻ�������С */ }
function HP_TcpAgent_GetSocketBufferSize(pAgent: HP_TcpAgent): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ���������� */ }
function HP_TcpAgent_GetKeepAliveTime(pAgent: HP_TcpAgent): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ��������� */ }
function HP_TcpAgent_GetKeepAliveInterval(pAgent: HP_TcpAgent): LongInt; stdcall; external HPSocketDLL;


{ /***************************** Client ����������� *****************************/ }

{ TODO
  * ���ƣ�����ͨ�����
  * �����������ͻ���ͨ����������ӷ���ˣ�������ɺ�ɿ�ʼ�շ�����
  *
  * ������		pszRemoteAddress	-- ����˵�ַ
  *			usPort				-- ����˶˿�
  *			bAsyncConnect		-- �Ƿ�����첽 Connect
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Client_Start(pClient: HP_Client; pszRemoteAddress: PWideChar; usPort: Word; bAsyncConnect: BOOL): BOOL;
stdcall; external HPSocketDLL;

{ TODO
  * ���ƣ��ر�ͨ�����
  * �������رտͻ���ͨ��������ر���ɺ�Ͽ������˵����Ӳ��ͷ�������Դ
  *
  * ������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� GetLastError() ��ȡ�������
  */ }
function HP_Client_Stop(pClient: HP_Client): BOOL; stdcall; external HPSocketDLL;

{ TODO
  * ���ƣ���������
  * �����������˷�������
  *
  * ������		pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_Send(pClient: HP_Client; const pBuffer: Pointer; iLength: Integer): BOOL; stdcall; external HPSocketDLL;

{ TODO
  * ���ƣ���������
  * �����������˷�������
  *
  * ������		pBuffer		-- ���ͻ�����
  *			iLength		-- ���ͻ���������
  *			iOffset		-- ���ͻ�����ָ��ƫ����
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_SendPart(pClient: HP_Client; const pBuffer: Pointer; iLength: Integer; iOffset: Integer): BOOL;
stdcall; external HPSocketDLL;

{ TODO
  * ���ƣ����Ͷ�������
  * �����������˷��Ͷ�������
  *		TCP - ˳�����������ݰ�
  *		UDP - ���������ݰ���ϳ�һ�����ݰ����ͣ����ݰ����ܳ��Ȳ��ܴ������õ� UDP ����󳤶ȣ�
  *
  * ������		pBuffers	-- ���ͻ���������
  *			iCount		-- ���ͻ�������Ŀ
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_Client_SendPackets(pClient: HP_Client; const pBuffers: WSABUFArray; iCount: Integer): BOOL; stdcall; external HPSocketDLL;

{ /******************************************************************************/
  /***************************** Client ���Է��ʷ��� *****************************/ }

{ TODO �������ӵĸ������� */ }
procedure HP_Client_SetExtra(pClient: HP_Client; pExtra: Pointer); stdcall; external HPSocketDLL;
{ TODO ��ȡ���ӵĸ������� */ }
function HP_Client_GetExtra(pClient: HP_Client): Pointer; stdcall; external HPSocketDLL;

{ TODO ���ͨ������Ƿ������� */ }
function HP_Client_HasStarted(pClient: HP_Client): BOOL; stdcall; external HPSocketDLL;
{ TODO �鿴ͨ�������ǰ״̬ */ }
function HP_Client_GetState(pClient: HP_Client): En_HP_ServiceState; stdcall; external HPSocketDLL;
{ TODO ��ȡ���һ��ʧ�ܲ����Ĵ������ */ }
function HP_Client_GetLastError(pClient: HP_Client): En_HP_SocketError; stdcall; external HPSocketDLL;
{ TODO ��ȡ���һ��ʧ�ܲ����Ĵ������� */ }
function HP_Client_GetLastErrorDesc(pClient: HP_Client): PWideChar; stdcall; external HPSocketDLL;
{ TODO ��ȡ�������������� ID */ }
function HP_Client_GetConnectionID(pClient: HP_Client): HP_CONNID; stdcall; external HPSocketDLL;
{ TODO ��ȡ Client Socket �ĵ�ַ��Ϣ */ }
function HP_Client_GetLocalAddress(pClient: HP_Client; lpszAddress: PWideChar; piAddressLen: PInteger; pusPort: PUShort): BOOL;
stdcall; external HPSocketDLL;
{ TODO ��ȡ������δ�������ݵĳ��� */ }
function HP_Client_GetPendingDataLength(pClient: HP_Client; piPending: PInteger): BOOL; stdcall; external HPSocketDLL;
{ TODO �����ڴ�黺��ش�С��ͨ������Ϊ -> PUSH ģ�ͣ�5 - 10��PULL ģ�ͣ�10 - 20 �� */ }
procedure HP_Client_SetFreeBufferPoolSize(pClient: HP_Client; dwFreeBufferPoolSize: LongInt); stdcall; external HPSocketDLL;
{ TODO �����ڴ�黺��ػ��շ�ֵ��ͨ������Ϊ�ڴ�黺��ش�С�� 3 ���� */ }
procedure HP_Client_SetFreeBufferPoolHold(pClient: HP_Client; dwFreeBufferPoolHold: LongInt); stdcall; external HPSocketDLL;
{ TODO ��ȡ�ڴ�黺��ش�С */ }
function HP_Client_GetFreeBufferPoolSize(pClient: HP_Client): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ�ڴ�黺��ػ��շ�ֵ */ }
function HP_Client_GetFreeBufferPoolHold(pClient: HP_Client): LongInt; stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /******************************* TCP Client �������� *******************************/ }

{ /*
  * ���ƣ�����С�ļ�
  * �����������˷��� 4096 KB ���µ�С�ļ�
  *
  * ������		lpszFileName	-- �ļ�·��
  *			pHead			-- ͷ����������
  *			pTail			-- β����������
  * ����ֵ��	TRUE	-- �ɹ�
  *			FALSE	-- ʧ�ܣ���ͨ�� Windows API ���� ::GetLastError() ��ȡ Windows �������
  */ }
function HP_TcpClient_SendSmallFile(pClient: HP_Client; lpszFileName: PWideChar; const pHead: LPWSABUF; const pTail: LPWSABUF): BOOL;
stdcall; external HPSocketDLL;

{ /**********************************************************************************/
  /***************************** TCP Client ���Է��ʷ��� *****************************/ }

{ TODO ����ͨ�����ݻ�������С������ƽ��ͨ�����ݰ���С�������ã�ͨ������Ϊ��(N * 1024) - sizeof(TBufferObj)�� */ }
procedure HP_TcpClient_SetSocketBufferSize(pClient: HP_TcpClient; dwSocketBufferSize: LongInt); stdcall; external HPSocketDLL;
{ TODO ������������������룬0 �򲻷����������� */ }
procedure HP_TcpClient_SetKeepAliveTime(pClient: HP_TcpClient; dwKeepAliveTime: LongInt); stdcall; external HPSocketDLL;
{ TODO ��������ȷ�ϰ�����������룬0 ������������������������ɴ� [Ĭ�ϣ�WinXP 5 ��, Win7 10 ��] ��ⲻ������ȷ�ϰ�����Ϊ�Ѷ��ߣ� */ }
procedure HP_TcpClient_SetKeepAliveInterval(pClient: HP_TcpClient; dwKeepAliveInterval: LongInt); stdcall; external HPSocketDLL;

{ TODO ��ȡͨ�����ݻ�������С */ }
function HP_TcpClient_GetSocketBufferSize(pClient: HP_TcpClient): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ���������� */ }
function HP_TcpClient_GetKeepAliveTime(pClient: HP_TcpClient): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ��������� */ }
function HP_TcpClient_GetKeepAliveInterval(pClient: HP_TcpClient): LongInt; stdcall; external HPSocketDLL;

{***************************** UDP Client ���Է��ʷ��� *****************************/ }

{ TODO �������ݱ�����󳤶ȣ������ھ����������²����� 1472 �ֽڣ��ڹ����������²����� 548 �ֽڣ� */ }
procedure HP_UdpClient_SetMaxDatagramSize(pClient: HP_UdpClient; dwMaxDatagramSize: LongInt); stdcall; external HPSocketDLL;
{ TODO ��ȡ���ݱ�����󳤶� */ }
function HP_UdpClient_GetMaxDatagramSize(pClient: HP_UdpClient): LongInt; stdcall; external HPSocketDLL;

{ TODO ���ü������Դ�����0 �򲻷��ͼ�������������������Դ�������Ϊ�Ѷ��ߣ� */ }
procedure HP_UdpClient_SetDetectAttempts(pClient: HP_UdpClient; dwDetectAttempts: LongInt); stdcall; external HPSocketDLL;
{ TODO ���ü������ͼ�����룬0 �����ͼ����� */ }
procedure HP_UdpClient_SetDetectInterval(pClient: HP_UdpClient; dwDetectInterval: LongInt); stdcall; external HPSocketDLL;
{ TODO ��ȡ���������� */ }
function HP_UdpClient_GetDetectAttempts(pClient: HP_UdpClient): LongInt; stdcall; external HPSocketDLL;
{ TODO ��ȡ��������� */ }
function HP_UdpClient_GetDetectInterval(pClient: HP_UdpClient): LongInt; stdcall; external HPSocketDLL;

{ ***************************** UDP Cast ���Է��ʷ��� *****************************/ }
{TODO �������ݱ�����󳤶ȣ������ھ����������²����� 1472 �ֽڣ��ڹ����������²����� 548 �ֽڣ� */}
procedure HP_UdpCast_SetMaxDatagramSize(pCast: HP_UdpCast; dwMaxDatagramSize: LongInt); stdcall; external HPSocketdll;
{TODO ��ȡ���ݱ�����󳤶� */ }
function HP_UdpCast_GetMaxDatagramSize(pCast: HP_UdpCast): LongInt; stdcall; external HPSocketdll;
{TODO ��ȡ��ǰ���ݱ���Զ�̵�ַ��Ϣ��ͨ���� OnReceive �¼��е��ã� */ }
function HP_UdpCast_GetRemoteAddress(pCast: HP_UdpCast; lpszAddress: PWideChar; piAddresslen: PInteger; pusPort: PUShort): BOOL;
stdcall; external HPSocketDLL;
{TODO ���ð󶨵�ַ */ }
procedure HP_UdpCast_SetBindAdddress(pCast: HP_UdpCast; pszBindAddress: PWideChar); stdcall; external HPSocketDll;
{TODO ��ȡ�󶨵�ַ */  }
function HP_UdpCast_GetBindAdddress(pCast: HP_UdpCast): WideChar; stdcall external HPSocketDll;
{TODO �����Ƿ����õ�ַ���û��ƣ�Ĭ�ϣ������ã� */  }
procedure HP_UdpCast_SetReuseAddress(pCast: HP_UdpCast; bReuseAddress: BOOL); stdcall; external HPSocketDll;
{TODO ����Ƿ����õ�ַ���û��� */  }
function HP_UdpCast_IsReuseAddress(pCast: HP_UdpCast): BOOL; stdcall; external HPSocketDll;
{TODO ���ô���ģʽ���鲥��㲥�� */  }
procedure HP_UdpCast_SetCastMode(pCast: HP_UdpCast; enCastMode: En_HP_CastMode); stdcall; external HPSocketDll;
{TODO ��ȡ����ģʽ */  }
function HP_UdpCast_GetCastMode(pCast: HP_UdpCast): En_HP_CastMode; stdcall; external HPSocketDll;
{TODO �����鲥���ĵ� TTL��0 - 255�� */    }
procedure HP_UdpCast_SetMultiCastTtl(PChar: HP_UdpCast; iMCTtl: LongInt); stdcall; external HPSocketDll;
{TODO ��ȡ�鲥���ĵ� TTL */ }
function HP_UdpCast_GetMultiCastTtl(PChar: HP_UdpCast): LongInt; stdcall; external HPSocketDll;
{TODO �����Ƿ������鲥��·��TRUE or FALSE�� */   }
procedure HP_UdpCast_SetMultiCastLoop(PChar: HP_UdpCast; bMCLoop: BOOL); stdcall; external HPSocketDll;
{TODO ����Ƿ������鲥��· */ }
function HP_UdpCast_IsMultiCastLoop(PChar: HP_UdpCast): BOOL; stdcall; external HPSocketDll;

{ **************************** TCP Pull Server ����������� *****************************/ }

{TODO
  * ���ƣ�ץȡ����
  * �������û�ͨ���÷����� Socket �����ץȡ����
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ����ץȡ������
  *			iLength		-- ץȡ���ݳ���
  * ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullServer_Fetch(pServer: HP_TcpPullServer; dwConnID: HP_CONNID; pData: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;

{  TODO
* ���ƣ���̽���ݣ������Ƴ����������ݣ�
* �������û�ͨ���÷����� Socket ����п�̽����
*
* ������		dwConnID	-- ���� ID
*			pData		-- ��̽������
*			iLength		-- ��̽���ݳ���
* ����ֵ��	En_HP_FetchResult
*/ }
function HP_TcpPullServer_Peek(pServer: HP_TcpPullServer; dwConnID: HP_CONNID; pData: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;

{ /***************************************************************************************/
  /***************************** TCP Pull Server ���Է��ʷ��� *****************************/ }

{ /***************************************************************************************/
  /***************************** TCP Pull Agent ����������� *****************************/ }

{ TODO
  * ���ƣ�ץȡ����
  * �������û�ͨ���÷����� Socket �����ץȡ����
  *
  * ������		dwConnID	-- ���� ID
  *			pBuffer		-- ����ץȡ������
  *			iLength		-- ץȡ���ݳ���
  * ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullAgent_Fetch(pAgent: HP_TcpPullAgent; dwConnID: HP_CONNID; pBuffer: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;

{TODO* ���ƣ���̽���ݣ������Ƴ����������ݣ�
* �������û�ͨ���÷����� Socket ����п�̽����
*
* ������		dwConnID	-- ���� ID
*			pData		-- ��̽������
*			iLength		-- ��̽���ݳ���
* ����ֵ��	En_HP_FetchResult   }
function HP_TcpPullAgent_Peek(pAgent: HP_TcpPullAgent; dwConnID: HP_CONNID; pBuffer: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;

{ ***************************** TCP Pull Client ����������� *****************************/ }
{ TODO
* ���ƣ�ץȡ����
* �������û�ͨ���÷����� Socket �����ץȡ����
*
* ������	dwConnID	-- ���� ID
*			    pData		-- ץȡ������
*		    	iLength		-- ץȡ���ݳ���
* ����ֵ��	En_HP_FetchResult
  */ }
function HP_TcpPullClient_Fetch(pClient: HP_TcpPullClient; pData: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;

{  TODO
* ���ƣ���̽���ݣ������Ƴ����������ݣ�
* �������û�ͨ���÷����� Socket ����п�̽����
*
* ������		dwConnID	-- ���� ID
*			pData		-- ��̽������
*			iLength		-- ��̽���ݳ���
* ����ֵ��	En_HP_FetchResult
*/ }
function HP_TcpPullClient_Peek(pClient: HP_TcpPullClient; pData: Pointer; iLength: Integer): En_HP_FetchResult;
stdcall; external HPSocketDLL;
{/***************************** TCP Pack Server ���Է��ʷ��� *****************************/ }

{TODO/* �������ݰ���󳤶ȣ���Ч���ݰ���󳤶Ȳ��ܳ��� 524287/0x7FFFF �ֽڣ�Ĭ�ϣ�262144/0x40000�� */}
procedure HP_TcpPackServer_SetMaxPackSize(pServer: HP_TcpPackServer ; dwMaxPackSize: LongWord); stdcall; external HPSocketDLL;
{TODO ���ð�ͷ��ʶ����Ч��ͷ��ʶȡֵ��Χ 0 ~ 8191/0x1FFF������ͷ��ʶΪ 0 ʱ��У���ͷ��Ĭ�ϣ�0�� */ }
procedure HP_TcpPackServer_SetPackHeaderFlag(pServer: HP_TcpPackServer ; usPackHeaderFlag: Word); stdcall; external HPSocketDLL;

{TODO ��ȡ���ݰ���󳤶� */ }
function HP_TcpPackServer_GetMaxPackSize(pServer: HP_TcpPackServer): LongWord; stdcall; external HPSocketDLL;
{TODO ��ȡ��ͷ��ʶ */     }
function HP_TcpPackServer_GetPackHeaderFlag(pServer: HP_TcpPackServer): Word; stdcall; external HPSocketDLL;

//***************************** TCP Pack Agent ���Է��ʷ��� *****************************/

{TODO �������ݰ���󳤶ȣ���Ч���ݰ���󳤶Ȳ��ܳ��� 524287/0x7FFFF �ֽڣ�Ĭ�ϣ�262144/0x40000�� */}
procedure HP_TcpPackAgent_SetMaxPackSize(pAgent: HP_TcpPackAgent; dwMaxPackSize: LongWord); stdcall; external HPSocketDLL;
{TODO ���ð�ͷ��ʶ����Ч��ͷ��ʶȡֵ��Χ 0 ~ 8191/0x1FFF������ͷ��ʶΪ 0 ʱ��У���ͷ��Ĭ�ϣ�0�� */ }
procedure HP_TcpPackAgent_SetPackHeaderFlag(pAgent: HP_TcpPackAgent; usPackHeaderFlag: Word); stdcall; external HPSocketDLL;

{TODO ��ȡ���ݰ���󳤶� */ }
function HP_TcpPackAgent_GetMaxPackSize(pAgent: HP_TcpPackAgent): LongWord; stdcall; external HPSocketDLL;
{TODO ��ȡ��ͷ��ʶ */ }
function HP_TcpPackAgent_GetPackHeaderFlag(pAgent: HP_TcpPackAgent): Word; stdcall; external HPSocketDLL;

//***************************** TCP Pack Client ���Է��ʷ��� *****************************/

{TODO  �������ݰ���󳤶ȣ���Ч���ݰ���󳤶Ȳ��ܳ��� 524287/0x7FFFF �ֽڣ�Ĭ�ϣ�262144/0x40000�� */  }
procedure HP_TcpPackClient_SetMaxPackSize(pClient: HP_TcpPackAgent; dwMaxPackSize: LongWord); stdcall; external HPSocketDLL;
{TODO  ���ð�ͷ��ʶ����Ч��ͷ��ʶȡֵ��Χ 0 ~ 8191/0x1FFF������ͷ��ʶΪ 0 ʱ��У���ͷ��Ĭ�ϣ�0�� */ }
procedure HP_TcpPackClient_SetPackHeaderFlag(pClient: HP_TcpPackAgent; usPackHeaderFlag: Word); stdcall; external HPSocketDLL;

{TODO  ��ȡ���ݰ���󳤶� */ }
function HP_TcpPackClient_GetMaxPackSize(pClient: HP_TcpPackAgent): LongWord; stdcall; external HPSocketDLL;
{TODO  ��ȡ��ͷ��ʶ */ }
function HP_TcpPackClient_GetPackHeaderFlag(pClient: HP_TcpPackAgent): Word; stdcall; external HPSocketDLL;

{ ************************************** �������� ***************************************/ }
{ /* ��ȡ���������ı� */ }
function HP_GetSocketErrorDesc(enCode: En_HP_SocketError): PWideChar; stdcall; external HPSocketDLL;
{ /* ����ϵͳ�� ::GetLastError() ������ȡϵͳ������� */ }
function SYS_GetLastError(): LongInt; stdcall; external HPSocketDLL;
// ����ϵͳ�� ::WSAGetLastError() ������ȡͨ�Ŵ������
function SYS_WSAGetLastError(): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� setsockopt()
function SYS_SetSocketOption(sock: SOCKET; level: Integer; name: Integer; val: pointer; len: Integer): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� getsockopt()
function SYS_GetSocketOption(sock: SOCKET; level: Integer; name: Integer; val: Pointer; len: PInteger): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� ioctlsocket()
function SYS_IoctlSocket(sock: SOCKET; cmd: LongInt; arg: PULONG): Integer; stdcall; external HPSocketDLL;
// ����ϵͳ�� ::WSAIoctl()
function SYS_WSAIoctl(sock: SOCKET; dwIoControlCode: LongInt; lpvInBuffer: pointer; cbInBuffer: LongInt; lpvOutBuffer: pointer; cbOutBuffer: LongInt; lpcbBytesReturned: LPDWORD): Integer; stdcall; external HPSocketDLL;


implementation


initialization
  IsMultiThread := True;
end.

