unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,HPSocketSDKUnit, ExtCtrls;

type
  TForm1 = class(TForm)
    lst: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    btn1: TButton;
    btn2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Pserver = Record
    DListener : Integer;
    DServer : Integer;
  end;

var
  Form1: TForm1;
  PPserver: pserver;
  cs:TRTLCriticalSection;
implementation

{$R *.dfm}
procedure AddMsg(str: string);
begin
  EnterCriticalSection(CS);
  Form1.lst.Items.Add('==> '+str);
  LeaveCriticalSection(CS);

end;

function OnPrepareListen(soListen: Pointer): En_HP_HandleResult; stdcall;
begin
    AddMsg('׼������ -> ' + inttostr(Integer(solisten)));
    Result := HP_HR_OK;
end;

function OnAccept(dwConnId: DWORD; pClient: Pointer): En_HP_HandleResult; stdcall;
var
    ip: array [0 .. 40] of WideChar;
    ipLength: Integer;
    port: Word;
begin
    ipLength := 40;
    if HP_Server_GetRemoteAddress(PPserver.DServer, dwConnId, ip, @ipLength, @port) then
    begin
      AddMsg('�������� -> '+  string(ip) +':'+ inttostr(port));
    end
    else
    begin
      AddMsg('ȡ������Ϣʧ�� -> ' + inttostr(dwConnId));
    end;
    Result := HP_HR_OK;
end;

function OnSend(dwConnId: DWORD; const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
begin
    AddMsg('�������� -> ' + inttostr(iLength) + ' bytes');
    Result := HP_HR_OK;
end;

function OnReceive(dwConnID: HP_CONNID;const pData: Pointer; iLength: Integer): En_HP_HandleResult; stdcall;
begin
     AddMsg('�յ����� -> ' + inttostr(iLength) + ' bytes');
     Result:= HP_HR_OK;
end;

function OnCloseConn(dwConnId: DWORD; enOperation: En_HP_SocketOperation; iErrorCode: Integer ): En_HP_HandleResult; stdcall;
begin
    AddMsg('���ӹر� -> ' + inttostr(Integer(dwConnId)));
    Result := HP_HR_OK;
end;

function OnShutdown(): En_HP_HandleResult; stdcall;
begin
    AddMsg('����ر� -> ');
    Result:= HP_HR_OK;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     // ��������������
    PPserver.DListener:= Create_HP_TcpServerListener();

    // ���� Socket ����
    PPserver.DServer := Create_HP_TcpServer(PPserver.DListener);

    // ���� Socket �������ص�����
    HP_Set_FN_Server_OnPrepareListen(PPserver.DListener, OnPrepareListen);
    HP_Set_FN_Server_OnAccept(PPserver.DListener, OnAccept);
    HP_Set_FN_Server_OnSend(PPserver.DListener, OnSend);
    HP_Set_FN_Server_OnReceive(PPserver.DListener, OnReceive);
    HP_Set_FN_Server_OnClose(PPserver.DListener, OnCloseConn);
    HP_Set_FN_Server_OnShutdown(PPserver.DListener, OnShutdown);

    // ����HPģʽΪ��������ģʽ
    HP_Server_SetSendPolicy(PPserver.DServer, HP_SP_DIRECT);

    //���ù����߳�
    HP_Server_SetWorkerThreadCount(PPserver.DServer, 30);

    //��ʼ���ٽ���
    InitializeCriticalSection(CS);

    AddMsg('ϵͳ��ʼ�����');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DeleteCriticalSection(CS);   //ɾ���ٽ���
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  Ip:WideString;
  Port:Word;
  errorId: En_HP_SocketError;
  errorMsg: WideString;
begin
    Ip := EDIT1.Text;
    Port := StrToInt(Edit2.TEXT);

    if HP_Server_Start(PPserver.DServer, ip, port) then
    begin
      AddMsg(Format('���������ɹ� -> (%s:%d)', [ip, port]));
    end
    else
    begin
        errorId := HP_Server_GetLastError(PPserver.DServer);
        errorMsg := HP_Server_GetLastErrorDesc(PPserver.DServer);
        AddMsg(Format('��������ʧ�� -> %s(%d)', [errorMsg, Integer(errorId)]));
    end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  if HP_Server_Stop(PPserver.DServer) then
  begin
    AddMsg('����ֹͣ�ɹ� -> ');
  end
  else
  begin
    AddMsg('����ֹͣʧ�� -> ');
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Count:Integer;
begin
    Count:= HP_Server_GetConnectionCount(PPserver.DServer);
    Label4.Caption:= IntToStr(Count);
end;

end.
