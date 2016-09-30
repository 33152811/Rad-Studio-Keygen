program RadStudioSlipDecode;

{$APPTYPE CONSOLE}

uses
  SysUtils,Classes,Windows;

procedure DecodeSlip(FileName:string);
var
  b1,b2,b3,b4:Byte;
  Verify,Len,v1,v2,v3:DWORD;
  MemoryStream:TMemoryStream;
  Slip:string;
begin
  MemoryStream:=TMemoryStream.Create;
  try
    MemoryStream.LoadFromFile(FileName);
    Verify:=PDWORD(MemoryStream.Memory)^;
    Verify:=(Swap(loWord(Verify)) shl 16) or Swap(HiWord(Verify));
    Len:=PDWORD(DWORD(MemoryStream.Memory)+4)^;
    Len:=(Swap(loWord(Len)) shl 16) or Swap(HiWord(Len));
    if Len<=MemoryStream.Size-8 then
    begin
      SetLength(Slip,Len);
      MoveMemory(@Slip[1],PDWORD(DWORD(MemoryStream.Memory)+8),Len);
      v1:=Verify;
      while Len>0 do
      begin
        v2:=v1;
        b1:= (v2 shr 24) and $ff;
        b2:= (v2 shr 16) and $ff;
        b3:= (v2 shr 8) and $ff;
        b4:= v2 and $ff;

        v2:=(b1 xor b2 xor b4 ) shl 24;
        v2:=v2 or ((b2 xor b3) shl 16);
        v2:=v2 or ((b3 xor b4) shl 8);
        v2:=v2 or b4;

        v3:=Ord(Slip[Len]);
        if (v3 and $80)=$80 then v3:=v3 or $ffffff00;
        v1:= v2 xor v3;
        Slip[Len]:=Chr(Ord(Slip[Len]) xor ((v1 shr 24) and $FF));
        Dec(Len);
      end;
      MemoryStream.Clear;
      MemoryStream.Write(Pointer(Slip)^,Length(Slip));
      MemoryStream.SaveToFile(ChangeFileExt(FileName,'.txt'));
      Writeln('Done!'+#9+FileName);
    end
    else
      Writeln('Length incorrect!'+#9+FileName);

  finally
    FreeAndNil(MemoryStream);
    SetLength(Slip,0);
  end;
end;

var
  i:Integer;
begin
  try
    if ParamCount>0 then
    begin
      for i := 1 to ParamCount do
      begin

        if FileExists(ExpandFileName(ParamStr(i))) then
            DecodeSlip(ExpandFileName(ParamStr(i)))
        else
          Writeln('File not exists!'+#9+ExpandFileName(ParamStr(i)));
      end;
    end
    else
    begin
      Writeln('Usage: RadStudioSlipDecode File1 File2 File3 ... FileN');
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
