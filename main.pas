unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  fphttpclient, opensslsockets, fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    add_word: TButton;
    login: TButton;
    word_type: TComboBox;
    email: TEdit;
    password: TEdit;
    new_word: TEdit;
    Generate_Joke: TButton;
    procedure add_wordClick(Sender: TObject);
    procedure loginClick(Sender: TObject);
    procedure emailChange(Sender: TObject);
    procedure Generate_JokeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure word_typeChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

  key:string;

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

function sign_in(email: string; password: string): String;
var
   send:string;
   Client: TFPHttpClient;
   Response: TStringStream;
   JsonData: TJSONData;
   JsonObj: TJSONObject;

begin
   //prep string
   send := '{"email" : "' + email + '", "password" : "' + password + '"}';

   Client := TFPHttpClient.Create(nil);
   Client.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fpweb)');
   Client.AddHeader('Content-Type', 'application/json; charset=UTF-8');
   Client.AddHeader('Accept', 'application/json');
   Client.AllowRedirect := true;

   Client.RequestBody := TRawByteStringStream.Create(send);
   Response := TStringStream.Create('');

   try
    try
      Client.Post('https://api.stanghelle.org/sign_in', Response);

    except on E: Exception do
      ShowMessage('Something bad happened: ' + E.Message);
    end;
  finally
    Client.RequestBody.Free;
    Client.Free;

    JsonData := GetJSON(Response.DataString);
    try
      if JsonData.JSONType = jtObject then
      begin
        JsonObj := JsonData as TJSONObject;
        key := JsonObj.Get('key', '');
      end;
    finally
      JsonData.Free;
    end;
    result := key;
    Response.Free;

  end;
end;

function log_in(email: string; password: string): String;
var
   send:string;
   Client: TFPHttpClient;
   Response: TStringStream;
   JsonData: TJSONData;
   JsonObj: TJSONObject;

begin
   //prep string
   send := '{"email" : "' + email + '", "password" : "' + password + '"}';

   Client := TFPHttpClient.Create(nil);
   Client.AddHeader('User-Agent', 'Mozilla/5.0 (compatible; fpweb)');
   Client.AddHeader('Content-Type', 'application/json; charset=UTF-8');
   Client.AddHeader('Accept', 'application/json');
   Client.AllowRedirect := true;

   Client.RequestBody := TRawByteStringStream.Create(send);
   Response := TStringStream.Create('');

   try
    try
      Client.Post('https://api.stanghelle.org/login', Response);

    except on E: Exception do
      ShowMessage('Something bad happened: ' + E.Message);
    end;
  finally
    Client.RequestBody.Free;
    Client.Free;

    JsonData := GetJSON(Response.DataString);
    try
      if JsonData.JSONType = jtObject then
      begin
        JsonObj := JsonData as TJSONObject;
        key := JsonObj.Get('key', '');
      end;
    finally
      JsonData.Free;
    end;
    result := key;
    Response.Free;

  end;
end;


function authenticate(email:string; password:string):Boolean;
var
   test:string;
begin
     test := log_in(email, password);

     if test = 'error' then
        test := sign_in(email, password);

     if test = 'error' then
        result := false
     else
     begin
         //key := test;
         result := true;
     end;
end;


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.word_typeChange(Sender: TObject);
begin

end;

procedure TForm1.Generate_JokeClick(Sender: TObject);
begin
     ShowMessage(get_joke);

end;

procedure TForm1.emailChange(Sender: TObject);
begin

end;

procedure TForm1.add_wordClick(Sender: TObject);
begin

end;

procedure TForm1.loginClick(Sender: TObject);
var
   email2:string;
   password2:string;
   auth_status:Boolean;

begin

     email2 := Self.email.Text;
     password2 := Self.password.Text;

     auth_status := authenticate(email2, password2);

     if auth_status = true then
        ShowMessage('authenticated good :)')
     else
         ShowMessage('authenticated bad >:(');


end;

end.

