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
    EditN: TEdit;
    EditT: TEdit;
    Label1: TLabel;
    LabelWat: TLabel;
    Labelmm: TLabel;
    LabelZ: TLabel;
    LabelD: TLabel;
    RBtn_N: TRadioButton;
    RBtn_T: TRadioButton;
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
  ie,t:Single;
  d:Double;
  amount:LongInt;

implementation

{$R *.lfm}

{ TForm1 }

procedure ReadMeasures;
var i,valcode:Integer;
begin
  SetLength(a,6);
  a[0]:=0;
  Val(Form1.Edit1.Text,a[1],valcode);
  Val(Form1.Edit2.Text,a[2],valcode);
  Val(Form1.Edit3.Text,a[3],valcode);
  Val(Form1.Edit4.Text,a[4],valcode);
  Val(Form1.Edit5.Text,a[5],valcode);
  Val(Form1.EditN.Text,n,valcode);
  Val(Form1.EditT.Text,t,valcode);

  Val(Form1.Edit6.Text,ie,valcode);
  ie:=ie/1000;
  for i:=1 to 5 do a[i]:=a[i]/1000; //SI m
end;

function FindAverage(a:Array of Single):Single;
var i:Word;
    avg:Single;
begin
  avg:=0;
  for i:=1 to Length(a)-1 do avg:=avg+a[i];
  avg:=avg/(Length(a)-1);
  FindAverage:=avg;
end;

function CalcErrors(a:Array of Single):Double;
var
  i:Word;
  ad:array of Double;
  sum2,d,d_t_r:Double;
begin
  SetLength(ad,6);
  ad[0]:=0;

  d:=0;
  for i:=1 to 5 do d:=d+a[i];
  d:=d/5;  //average thickness of pack
  for i:=1 to 5 do ad[i]:=d-a[i];  //deviation

  sum2:=0;
  for i:=1 to 5 do sum2:=sum2+ ad[i]*ad[i];
  sum2:=sum2/(5*(5-1));
  sum2:=Sqrt(sum2);  //rMS error
  d_t_r:=2.8*sum2;  //random error
  CalcErrors:=Sqrt(d_t_r*d_t_r+ie*ie); //full error
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sd,sabs:String;
  eps,d_abs:Double;

begin
  ReadMeasures;
  d:=FindAverage(a);
  eps:=CalcErrors(a);
  d_abs:=eps*d;

  if Form1.RBtn_N.Checked then
  begin
    Str(d*1000000/n:0:1,sd);
    Str(d_abs*1000000/n:0:2,sabs);
    Label1.Caption:='Толщина 1 листа, мкм: '+sd+'~'+sabs;
  end;
  if Form1.RBtn_T.Checked then
  begin
    amount:=Round(d*1000000/t);
    Str(amount,sd);
    Label1.Caption:='В пачке '+sd+' листов';
  end;
end;

end.

