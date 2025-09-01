unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, fphttpclient, opensslsockets, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Generate_Joke: TButton;
    procedure Generate_JokeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{Helper funcs}

function get_joke:string;
var
  joke_json:string;
  JsonObject:TJsonObject;
  joke:string;
begin

     try
        joke_json := TFPHTTPClient.SimpleGet('https://api.stanghelle.org/joke');

        JsonObject := TJSONObject(GetJson(joke_json));

        joke := JSONObject.Get('joke', 'error');

        Result := joke;
     except
     on E: Exception do
        Result := e.Message;
     end;

end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Generate_JokeClick(Sender: TObject);
begin
     ShowMessage(get_joke);
end;

end.

