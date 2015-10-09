unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    EditN1: TEdit;
    Label1: TLabel;
    Labelmm: TLabel;
    LabelN: TLabel;
    LabelZ: TLabel;
    LabelD: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  a:array of Single;  //thickness measures
  n:Word;    //of N sheets
  ad:array of Double;
  ie:Single;  //instrument error

implementation

{$R *.lfm}

{ TForm1 }

procedure ReadArrays;
var valcode:Integer;
begin
  SetLength(a,6);
  a[0]:=0;
  Val(Form1.Edit1.Text,a[1],valcode);
  Val(Form1.Edit2.Text,a[2],valcode);
  Val(Form1.Edit3.Text,a[3],valcode);
  Val(Form1.Edit4.Text,a[4],valcode);
  Val(Form1.Edit5.Text,a[5],valcode);
  Val(Form1.EditN1.Text,n,valcode);
  SetLength(ad,6);
  ad[0]:=0;
  Val(Form1.Edit6.Text,ie,valcode);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:Word;
  sd,sabs:String;
  sum2,d,d_t_r,d_t,eps,d_abs:Double;

begin
  ReadArrays;
  ie:=ie/1000;
  for i:=1 to 5 do a[i]:=a[i]/1000; //SI m
  d:=0;
  for i:=1 to 5 do d:=d+a[i];
  d:=d/5;  //average thickness of pack
  for i:=1 to 5 do ad[i]:=d-a[i];  //deviation

  sum2:=0;
  for i:=1 to 5 do sum2:=sum2+ ad[i]*ad[i];
  sum2:=sum2/(5*(5-1));
  sum2:=Sqrt(sum2);  //rMS error
  d_t_r:=2.8*sum2;  //random error
  d_t:=Sqrt(d_t_r*d_t_r+ie*ie); //full error

  eps:=d_t/d;
  d_abs:=eps*d;

  Str(d/n*1000000:0:1,sd);
  Str(d_abs/n*1000000:0:2,sabs);
  Label1.Caption:='Толщина 1 листа, мкм: '+sd+'~'+sabs;
end;

end.

