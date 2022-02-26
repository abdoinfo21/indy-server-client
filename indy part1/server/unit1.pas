unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, IdTCPServer, IdCustomTCPServer, IdContext;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    TCPServer: TIdTCPServer;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure TCPServerExecute(AContext: TIdContext);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  TCPServer.Bindings.add.Port:=6666;
  TCPServer.Bindings.Add.IP:='0.0.0.0';
  TCPServer.Active:=true;
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

end.

