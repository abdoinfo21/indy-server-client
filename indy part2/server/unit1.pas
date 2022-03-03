unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  IdTCPServer, IdCustomTCPServer, IdContext;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    TCPServer: TIdTCPServer;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerDisconnect(AContext: TIdContext);
    procedure TCPServerExecute(AContext: TIdContext);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function change(n:string):string;
var
  i:integer;
begin
   for i:=0 to length(n) do
   begin
     if n[i]=':' then
      n[i]:='-';
   end;
   Result:=n;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   try
  TCPServer.Active:=true;
   finally
     memo1.Lines.Add('listening');
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TCPServer.Bindings.add.Port:=6666;
  TCPServer.Bindings.Add.IP:='0.0.0.0';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TCPserver.Active:=false;
end;

procedure TForm1.TCPServerConnect(AContext: TIdContext);
begin
  memo1.Lines.Add('server connected to : '+ AContext.Binding.PeerIP +':'+inttostr(AContext.Binding.PeerPort));
end;

procedure TForm1.TCPServerDisconnect(AContext: TIdContext);
begin
memo1.Lines.Add('server diconnected : '+ AContext.Binding.PeerIP +':'+inttostr(AContext.Binding.PeerPort));
end;

procedure TForm1.TCPServerExecute(AContext: TIdContext);
var
  ms:Tmemorystream;
  size:integer;
begin
    try
      ms:=Tmemorystream.Create;
      try
        size:=AContext.Connection.IOHandler.ReadLongInt();
        AContext.Connection.IOHandler.ReadStream(ms,size,false);
        ms.SaveToFile('0.png');
      finally
        ms.Free;
      end;
    except
      showmessage('receiving faild...');
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  n:string;
begin
  if FileExists('0.png') then
  begin
  sleep(1000);
  n:=timetostr(now);
  n:=change(n);
  if not RenameFile('0.png',n+'.png')then
  memo1.Lines.Add('failed to rename file');
  end;
end;

end.

