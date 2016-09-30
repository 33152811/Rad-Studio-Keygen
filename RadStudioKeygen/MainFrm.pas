unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,RadVersion;

type
  TFrmMain = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    function GetCurrentVersion():PRadStudioVersion;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
    
implementation
uses RadKeygen;
{$R *.dfm}

function TFrmMain.GetCurrentVersion():PRadStudioVersion;
begin
  Result:=PRadStudioVersion(RadStudioVersionList.Objects[ComboBox1.ItemIndex]);
end;  

procedure TFrmMain.Button1Click(Sender: TObject);
var
  FileName:string;
begin
  Edit1.Text:= RadKeygen.GenerateSerialNumber;
  if Edit2.Text='' then Edit2.Text:= RadKeygen.GetRegistrationCode;
  if Trim(Edit2.Text)<>'' then
  begin
    if RadKeygen.GenerateLicenseFile(Edit1.Text,Edit2.Text,GetCurrentVersion,FileName) then
    begin
      MessageBox(Handle,PChar('Slip files have been saved successfully!'#10+FileName),PChar(Application.Title),MB_OK+MB_ICONINFORMATION);
    end
    else
    begin
      MessageBox(Handle,PChar('An error has occured while save the slip file!'),PChar(Application.Title),MB_OK+MB_ICONWARNING);
    end;  
  end;
end;

procedure TFrmMain.Button2Click(Sender: TObject);
var
  FileName:string;
begin
  if RadKeygen.PatchFile(GetCurrentVersion,FileName) then
  begin
    MessageBox(Handle,PChar('path files have been saved successfully!'#10+FileName),PChar(Application.Title),MB_OK+MB_ICONINFORMATION);
  end
  else
  begin
    MessageBox(Handle,PChar('An error has occured while patch file!'),PChar(Application.Title),MB_OK+MB_ICONWARNING);
  end;
end;

procedure TFrmMain.ComboBox1Change(Sender: TObject);
var
  HowToUse:string;
begin
  HowToUse:='How to Use:' + sLineBreak;
  HowToUse:=HowToUse + '1. Download iso image file:' + sLineBreak;
  HowToUse:=HowToUse + '    %s' + sLineBreak;
  HowToUse:=HowToUse + '    MD5:%s' + sLineBreak;
  HowToUse:=HowToUse + '    Version:%s' + sLineBreak;
  HowToUse:=HowToUse + '2. Mount *.iso image and run intstallation process, select language,' + sLineBreak;
  HowToUse:=HowToUse + '    Set Checkbox that you agree with License agreement, click "Next >" ' + sLineBreak;
  HowToUse:=HowToUse + '    Now you are on the "Input License" page...' + sLineBreak;
  HowToUse:=HowToUse + '3. Click "< Back" button ' + sLineBreak;
  HowToUse:=HowToUse + '    Now use keygen...' + sLineBreak;
  HowToUse:=HowToUse + '4. Click "Generate" to get new Serial Number. ' + sLineBreak;
  HowToUse:=HowToUse + '    !!! Do not use any other serial numbers from internet !!! ' + sLineBreak;
  HowToUse:=HowToUse + '5. now click "Next >" in the Setup page and continue installation process...  ' + sLineBreak;
  HowToUse:=HowToUse + '6. When Installation has finished, click "Patch". ' + sLineBreak;
  HowToUse:=HowToUse + '7. Start RAD Studio. ' + sLineBreak;
  HowToUse:=HowToUse + '====================================================' + sLineBreak;
  HowToUse:=HowToUse + 'Enjoy!!!';
  Memo1.Clear;
  Memo1.Lines.Text:=Format(HowToUse,[GetCurrentVersion^.ISOUrl,GetCurrentVersion^.ISOMd5,GetCurrentVersion^.Ver]);
  Caption:= Format('Rad Studio Keygen - %s',[GetCurrentVersion^.Name]);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.AddStrings(RadStudioVersionList);
  if ComboBox1.Items.Count>0 then
  begin
    ComboBox1.ItemIndex:=0;
    ComboBox1Change(ComboBox1);
  end;
  Edit1.Text:= RadKeygen.GenerateSerialNumber;
  Edit2.Text:= RadKeygen.GetRegistrationCode;  
end;

end.
