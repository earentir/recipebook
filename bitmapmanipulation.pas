unit bitmapmanipulation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, base64;

function bitmaptobase64(filename: string): string;
function base64tostream(base64: string): TStream;

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

      encoder.Free;
    end;

    filedata.Free;
    output.Free;
  end
  else
    Result := '';
end;

function base64tostream(base64: string): TStream;
var
  encodedata: TStringStream;
  decodedata: TMemoryStream;
  decoder: TBase64DecodingStream;
begin

  if base64 <> '' then
  begin
    encodedata := TStringStream.Create(base64);

    decodedata := TMemoryStream.Create;
    decoder := TBase64DecodingStream.Create(encodedata);

    decodedata.CopyFrom(decoder, decoder.Size);
    decodedata.Position := 0;

    Result := decodedata;
  end;

  encodedata.Free;
  //decodedata.Free;
  decoder.Free;
end;

end.
