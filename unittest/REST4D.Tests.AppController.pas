unit REST4D.Tests.AppController;

interface

uses
  REST4D,
  REST4D.Server,
  System.Generics.Collections,
  System.SysUtils;

type

  TUser = class
  strict private
    FCod: Integer;
    FName: string;
    FPass: string;
  public
    property Cod: Integer read FCod write FCod;
    property Name: string read FName write FName;
    property Pass: string read FPass write FPass;
  end;

  [Path('/')]
  TAppController = class(TRESTController)
  public
    [Path('/hello')]
    [HTTPMethod([THTTPMethod.httpGET])]
    procedure HelloWorld(ctx: TRESTWebContext);

    [Path('/user')]
    [HTTPMethod([THTTPMethod.httpGET])]
    procedure GetUser(ctx: TRESTWebContext);

    [Path('/user/save')]
    [HTTPMethod([THTTPMethod.httpPOST])]
    procedure PostUser(ctx: TRESTWebContext);

    [Path('/users')]
    [HTTPMethod([THTTPMethod.httpGET])]
    procedure GetUsers(ctx: TRESTWebContext);

    [Path('/users/save')]
    [HTTPMethod([THTTPMethod.httpPOST])]
    procedure PostUsers(ctx: TRESTWebContext);
  end;

implementation


{ TAppController }

procedure TAppController.GetUser(ctx: TRESTWebContext);
var
  vUser: TUser;
begin
  vUser := TUser.Create;
  vUser.Cod := 1;
  vUser.Name := 'Ezequiel';
  vUser.Pass := '123';

  Render(vUser);
end;

procedure TAppController.GetUsers(ctx: TRESTWebContext);
var
  vUsers: TObjectList<TUser>;
  vUser: TUser;
  I: Integer;
begin
  vUsers := TObjectList<TUser>.Create(True);

  for I := 0 to 10 do
  begin
    vUser := TUser.Create;
    vUser.Cod := I;
    vUser.Name := 'Ezequiel ' + IntToStr(I);
    vUser.Pass := IntToStr(I);

    vUsers.Add(vUser);
  end;

  Self.Render<TUser>(vUsers);
end;

procedure TAppController.HelloWorld(ctx: TRESTWebContext);
begin
  Render('Hello World called with GET');
end;

procedure TAppController.PostUser(ctx: TRESTWebContext);
var
  vUser: TUser;
begin
  vUser := ctx.Request.BodyAs<TUser>();

  if (vUser.Cod > 0) then
    Render('Sucess!')
  else
    Render('Error!');

  FreeAndNil(vUser);
end;

procedure TAppController.PostUsers(ctx: TRESTWebContext);
var
  vUsers: TObjectList<TUser>;
begin
  vUsers := ctx.Request.BodyAsListOf<TUser>();
  vUsers.OwnsObjects := True;

  if (vUsers.Count > 0) then
    Render('Sucess!')
  else
    Render('Error!');

  FreeAndNil(vUsers);
end;

end.
