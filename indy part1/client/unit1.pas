unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, IdTCPClient;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    TCPClient: TIdTCPClient;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  if button1.Caption='connect' then
  begin
  try
    TCPClient.Connect(edit1.text,strtoint(edit2.text));
    button1.Caption:='disconnect';
  finally
    memo1.Lines.add('connected');
  end;
  end
  else
  begin
   TCPClient.Disconnect();
   button1.Caption:='connect';
   memo1.Lines.Add('disconnected');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ms:Tmemorystream;
  pic:Tpicture;
  bmp:Tbitmap;
begin

  try
    ms:=Tmemorystream.Create;
    pic:=Tpicture.Create;
    bmp:=Tbitmap.Create;
    try
      pic.LoadFromFile('0.png');
      bmp.Height:=pic.Height;
      bmp.Width:=pic.Width;
      bmp.Canvas.Draw(0,0,pic.Graphic);
      bmp.SaveToStream(ms);
      ms.Position:=0;
      TCPClient.IOHandler.Write(ms.Size);
      TCPClient.IOHandler.Write(ms);
      memo1.Lines.add('sending...');
    finally
      ms.Free;
      pic.Free;
      bmp.Free;
    end;
  except
    showmessage('sending faild...');
  end;

end;
end.

