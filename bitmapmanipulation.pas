unit bitmapmanipulation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, base64;

function bitmaptobase64(filename: string): string;

implementation

function bitmaptobase64(filename: string): string;
var
  filedata: TStream;
  encoder: TBase64EncodingStream;
  output: TStringStream;
begin
  if FileExists(filename) then
  begin
    output := TStringStream.Create('');
    filedata := TFileStream.Create(filename, fmOpenRead);
    if filedata.Size > 0 then
    begin
      encoder := TBase64EncodingStream.Create(output);

      encoder.CopyFrom(filedata, filedata.Size);
      Result := output.DataString;
    end;
  end;
end;

end.







