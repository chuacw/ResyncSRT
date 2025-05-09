unit FMX.ExtCtrls.Vcl;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type

  TCustomLabeledEdit = class(TLayout)
  public
    type
      TLabelPosition = (lpAbove, lpBelow, lpLeft, lpRight);
  private
    FEditLabel: TLabel;
    FEdit: TEdit;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    FAlignment: TAlignment;
    procedure RecalculatePosition;
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
    procedure SetAlignment(const Value: TAlignment);
    procedure AdjustSize;
    function GetText: string;
    procedure SetText(const Value: string);

    function GetHeight: Integer; reintroduce;
    function GetLeft: Integer; reintroduce;
    function GetTop: Integer; reintroduce;
    function GetWidth: Integer; reintroduce;
    procedure SetHeight(const Value: Integer); reintroduce;
    procedure SetLeft(const Value: Integer); reintroduce;
    procedure SetTop(const Value: Integer); reintroduce;
    procedure SetWidth(const Value: Integer); reintroduce;
  protected
    procedure DefineProperties(Filer: TFiler); override;

    procedure ReadEditLabelCaption(Reader: TReader);
    procedure ReadEditLabelHeight(Reader: TReader);
    procedure ReadEditLabelWidth(Reader: TReader);
    procedure ReadLeft(Reader: TReader);
    procedure ReadTop(Reader: TReader);
    procedure ReadWidth(Reader: TReader);
    procedure ReadHeight(Reader: TReader);

    procedure Resize; override;

    procedure WriteEditLabelCaption(Writer: TWriter);
    procedure WriteEditLabelHeight(Writer: TWriter);
    procedure WriteEditLabelWidth(Writer: TWriter);
    procedure WriteLeft(Writer: TWriter);
    procedure WriteTop(Writer: TWriter);
    procedure WriteWidth(Writer: TWriter);
    procedure WriteHeight(Writer: TWriter);

    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    [Stored(False)]
    property Position;

    [Stored(False)]
    property Size;

    [Stored(False)]
    property TabOrder;

    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property EditLabel: TLabel read FEditLabel;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
    property Text: string read GetText write SetText;
  end;

  /// <summary> Implements TLabeledEdit functionality like that of the VCL
  /// </summary>
  TLabeledEdit = class(TCustomLabeledEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Left;
    property Top;
    property Width;
    property Height;
    property EditLabel;
    property LabelPosition;
    property LabelSpacing;
    property TabOrder;
    property Text;
  end;

  TPresentedTextControlClass = class of TPresentedTextControl;

  TCustomItemGroup = class abstract(TGroupBox)
  protected
    FItems: TList;
    FItemNames: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    procedure SetItemIndex(Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetColumns(Value: Integer);
  protected
    procedure ButtonClick(Sender: TObject);
//    procedure ButtonDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
//        var Operation: TDragOperation);
    /// <summary> Specifies the type of items to create, eg, TRadioButton or TCheckBox
    /// </summary>
    function ComponentItemClass: TPresentedTextControlClass; virtual; abstract;
    function GetParentClassStyleLookupName: string; override;
    /// <summary> Creates items if FItems isn't empty. Frees radio buttons if FItems is empty.
    /// </summary>
    procedure RecreateOrFreeItems;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItemNames write SetItems;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    function GetItem(const AIndex: Integer): TFmxObject;
//    function GetItemsCount: Integer;

    [Stored(False)]
    property ClipChildren;
  end;

  TCustomItemGroup<T: TPresentedTextControl> = class(TCustomItemGroup)
  protected
    function ComponentItemClass: TPresentedTextControlClass; override;
    function GetItem(Index: Integer): T;
    property Item[Index: Integer]: T read GetItem; default;
  published
    property Columns;
    property ItemIndex;
    property Items;
    property OnClick;
  end;

  TCustomRadioGroup   = TCustomItemGroup<TRadioButton>;
  TCustomCheckListBox = TCustomItemGroup<TCheckBox>;

  /// <summary> Implements TRadioGroup functionality like that of the VCL. </summary>
  TRadioGroup = class(TCustomRadioGroup)
  protected
  /// <summary> inherits the style of a GroupBox, so that the borders and text looks like that of a GroupBox.
  /// </summary>
  /// <remarks> Each component has to override its own GetDefaultStyleLookUpName, as the DefaultStyleLookupName is
  /// based on its ClassName. </remarks>
    function GetDefaultStyleLookupName: string; override;
  end;

  /// <summary> Implements TCheckListBox functionality like that of the VCL. </summary>
  TCheckListBox = class(TCustomCheckListBox)
  protected
  /// <summary> inherits the style of a GroupBox, so that the borders and text looks like that of a GroupBox.
  /// </summary>
  /// <remarks> Each component has to override its own GetDefaultStyleLookUpName, as the DefaultStyleLookupName is
  /// based on its ClassName. </remarks>
    function GetDefaultStyleLookupName: string; override;
  end;

procedure Register;

implementation
uses
  FMX.Platform, System.Types, System.Math, FMX.ActnList, System.Rtti;

procedure Register;
begin
  RegisterComponents('Additional', [TLabeledEdit, TCheckListBox]);
  RegisterComponents('Standard', [TRadioGroup]);
end;

{ TCustomRadioGroup }

procedure TCustomItemGroup.ButtonClick(Sender: TObject);
begin
  FItemIndex := FItems.IndexOf(Sender);
  if Assigned(OnClick) then
    OnClick(Sender);
end;

constructor TCustomItemGroup.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TList.Create;
  FItemNames := TStringList.Create;
  FItemIndex := -1;
  ClipChildren := True;
  SetAcceptsControls(False);
  FColumns := 1;
end;

procedure TCustomItemGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  try
    inherited ReadState(Reader);
  finally
    FReading := False;
  end;
end;

procedure TCustomItemGroup.RecreateOrFreeItems;
var
  I: Integer; LPrevTop: Single;
  LItem: TPresentedTextControl;
  TopMargin, ButtonsPerCol, ButtonWidth, ButtonHeight, MetricsHeight: Integer;
  DefMetricsSrv: IFMXDefaultMetricsService;
  LItemClass: TPresentedTextControlClass;
  LGroupName: IGroupName;
begin
  // Frees TRadioButtons / TCheckBoxes added with AddObject
  // Children contains other objects, such as TStyle too, so need to check
  // the type to be freed is correct.

  LItemClass := ComponentItemClass;

  if Assigned(Children) then
    for I := Children.Count-1 downto 0 do
      if Children.Items[I] is LItemClass then
        Children.Items[I].Free;

  if FItemNames.Count>0 then
    begin

      FItems.Clear;

      if SupportsPlatformService(IFMXDefaultMetricsService, DefMetricsSrv) and
        DefMetricsSrv.SupportsDefaultSize(TComponentKind.RadioButton) then
        MetricsHeight := DefMetricsSrv.GetDefaultSize(TComponentKind.RadioButton).Height
      else
        MetricsHeight := 19;

      ButtonsPerCol := (FItemNames.Count + FColumns - 1) div FColumns;
      ButtonWidth := Round(Width - 10) div FColumns;
      I := Round(Height - MetricsHeight - 5);
      ButtonHeight := I div ButtonsPerCol;
      TopMargin := MetricsHeight + 1 + (I mod ButtonsPerCol) div 2;

      LPrevTop := Canvas.TextHeight(Text);
      for I := 0 to FItemNames.Count-1 do
        begin
          LItem :=  LItemClass.Create(nil); // change nil to Self?
          LItem.Text := FItemNames[I];
          LItem.Position.X := (I div ButtonsPerCol) * ButtonWidth + 8;
          LItem.Position.Y := (I mod ButtonsPerCol) * ButtonHeight + TopMargin;
          LItem.Stored := False; // so that it's not persisted
          LItem.ClipParent := False;
    // So that it's mutually exclusive with other TRadioGroup's buttons when selected
    // otherwise, if this isn't set, selecting any button in a radio group will cause
    // all other radio buttons in other groups to be unchecked.
          if Supports(LItem, IGroupName, LGroupName) then
            LGroupName.GroupName := Name;
          LItem.OnClick := ButtonClick;
          LItem.Width  := ButtonWidth;
          LItem.Height := ButtonHeight;
    // prevents button/checkbox from being moved or deleted during design-time
          LItem.Locked := True;

          LPrevTop := LPrevTop + Canvas.TextHeight(LItem.Text);
          FItems.Add(LItem);
          AddObject(LItem);
        end;
    end;
end;

procedure TCustomItemGroup.DefineProperties(Filer: TFiler);
begin
  inherited;
// don't persist ClipChildren
  Filer.DefineProperty('ClipChildren', nil, nil, False);
  Filer.DefineProperty('AbsoluteEnabled', nil, nil, False);
end;

destructor TCustomItemGroup.Destroy;
begin
  TStringList(FItemNames).OnChange := nil;
  FItemNames.Clear;
  RecreateOrFreeItems;
  FItems.Free;
  inherited;
end;

function TCustomItemGroup.GetParentClassStyleLookupName: string;
begin
  Result := GenerateStyleName(TGroupBox.ClassParent.ClassName);
end;

procedure TCustomItemGroup.Loaded;
begin
  inherited;
  RecreateOrFreeItems;
end;

procedure TCustomItemGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 16 then Value := 16;
  if FColumns <> Value then
    begin
      FColumns := Value;
      RecreateOrFreeItems;
    end;
end;

procedure TCustomItemGroup.SetItemIndex(Value: Integer);

  procedure ChangeChecked(AComponent: TComponent; AChecked: Boolean);
  var
    LIsChecked: IIsChecked;
    LContext: TRttiContext;
    LType: TRttiType;
    LProperty: TRttiProperty;
  begin
    if Supports(AComponent, IIsChecked, LIsChecked) then
      LIsChecked.IsChecked := AChecked else
    begin
      LContext := TRttiContext.Create;
      LType := LContext.GetType(AComponent.ClassType);
      if Assigned(LType) then
        LProperty := LType.GetProperty('IsChecked') else
        LProperty := nil;
      if Assigned(LProperty) then
        LProperty.SetValue(AComponent, AChecked);
    end
  end;

var
  LComponent: TComponent;
  I: Integer;
begin

  if Value <= -1 then
    begin
      for I := 0 to FItems.Count-1 do
        begin
          LComponent := FItems[I];
          ChangeChecked(LComponent, False);
        end;
      Exit;
    end;

  if Value >= FItems.Count then Value := FItems.Count - 1;
  FItemIndex := Value;
  if Value >= 0 then
    begin
      LComponent := FItems[Value];
      ChangeChecked(LComponent, True);
    end;
end;

procedure TCustomItemGroup.SetItems(const Value: TStrings);
begin
  FItemNames.Assign(Value);
  RecreateOrFreeItems;
end;

{ TRadioGroup }

// For inheriting the style of a GroupBox
function TRadioGroup.GetDefaultStyleLookupName: string;
begin
  Result := inherited;
  Result := StringReplace(Result, 'RadioGroup', 'GroupBox', []);
end;

type
  /// <summary>  For use within a TCustomLabeledEdit
  /// </summary>
  TBoundEdit = class(TEdit)
  protected
    procedure DefineProperties(Filer: TFiler); override;
    /// <summary> Override default style lookup name so that it still looks like
    ///  an edit. </summary>
    function GetDefaultStyleLookupName: string; override;
  end;

  TCustomBoundLabel = class(TLabel)
  private
    function GetText: string;
    procedure SetText(const Value: string); reintroduce;

    procedure ReadCaption(Reader: TReader);
    procedure WriteCaption(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    [Stored(False)]
    property FocusControl;

    [Stored(False)]
    property Locked;

    [Stored(False)]
    property Size;

    [Stored(False)]
    property TabOrder;

//    [Stored(False)]
//    property Text;

    property Caption: string read GetText write SetText;
  published
    [Stored(False)]
    property Text stored False;
  end;

  /// <summary>  For use within a TCustomLabeledEdit
  /// </summary>
  TBoundLabel = class(TCustomBoundLabel)
  protected
    procedure DefineProperties(Filer: TFiler); override;
    /// <summary> Override default style lookup name so that it still looks like
    ///  a label.
    /// </summary>
    function GetDefaultStyleLookupName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TCustomItemGroup<T> }

function TCustomItemGroup<T>.ComponentItemClass: TPresentedTextControlClass;
begin
  Result := T;
end;

function TCustomItemGroup<T>.GetItem(Index: Integer): T;
begin
  Result := T(FItems[Index]);
end;

{ TCustomLabeledEdit }

procedure TCustomLabeledEdit.AdjustSize;
begin
  case FLabelPosition of
    lpAbove, lpBelow: begin
      Width  := Round(Max(FEditLabel.Width, FEdit.Width) + (FLabelSpacing * 2));
      Height := Round(FEditLabel.Height + FEdit.Height + (FLabelSpacing * 2));
    end;
    lpLeft, lpRight: begin
      Width  := Round(FEditLabel.Width + FEdit.Width + (FLabelSpacing * 2));
      Height := Round(Max(FEditLabel.Height, FEdit.Height) + (FLabelSpacing *2));
    end;
  end;
  FEdit.Position.X := FEditLabel.Position.X + FEditLabel.Width + FLabelSpacing;
  FEdit.Position.Y := FEditLabel.Position.Y;
end;

constructor TCustomLabeledEdit.Create(AOwner: TComponent);
var
  DefMetricsSrv: IFMXDefaultMetricsService;
  LEditHeight, LLabelHeight: Integer;
begin
  inherited;
  SetAcceptsControls(False); // Do not allow any child controls to be placed during design-time
  FAlignment := taLeftJustify;

  FEditLabel := TBoundLabel.Create(Self);
  FEditLabel.Parent := Self;
  // Prevents the edit label from being moved during design-time
  FEditLabel.Locked := True;
  // Prevents the edit label from being saved
  FEditLabel.Stored := False;
  FEditLabel.Position.X := 0;
  FEditLabel.Position.Y := FLabelSpacing;
  FEditLabel.Text := 'Label';
  if Assigned(Canvas) then
    FEditLabel.Width := Canvas.TextWidth(FEditLabel.Text) else
    FEditLabel.Width := 30;

  FLabelSpacing := 3;

  FEdit      := TBoundEdit.Create(Self);
  FEdit.Parent := Self;
  // Prevents the edit from being moved during design-time
  FEdit.Locked := True;
  // Prevents the edit from being saved
  FEdit.Stored := False;
  FEdit.Position.X := FEditLabel.Position.X + FEditLabel.Width + FLabelSpacing;
  FEdit.Position.Y := FEditLabel.Position.Y;

  if SupportsPlatformService(IFMXDefaultMetricsService, DefMetricsSrv) then
    begin
      if DefMetricsSrv.SupportsDefaultSize(TComponentKind.Edit) then
        begin
          LEditHeight := DefMetricsSrv.GetDefaultSize(TComponentKind.Edit).Height;
          FEdit.Height := Max(FEdit.Height, LEditHeight);
        end;
      if DefMetricsSrv.SupportsDefaultSize(TComponentKind.&Label) then
        begin
          LLabelHeight := DefMetricsSrv.GetDefaultSize(TComponentKind.&Label).Height;
          FEditLabel.Height := Max(FEditLabel.Height, LLabelHeight);
        end;
    end;

  Width  := Round(FEditLabel.Width + FEdit.Width + (FLabelSpacing * 2));
  Height := Round(FEditLabel.Height + FEdit.Height + (FLabelSpacing * 2));

  FEditLabel.FocusControl := FEdit;

  LabelPosition := lpLeft;
  AdjustSize;

end;

procedure TCustomLabeledEdit.DefineProperties(Filer: TFiler);
begin
  inherited;
//  Filer.DefineProperty('Left',   ReadLeft,   WriteLeft,   True);
//  Filer.DefineProperty('Top',    ReadTop,    WriteTop,    True);
//  Filer.DefineProperty('Width',  ReadWidth,  WriteWidth,  True);
//  Filer.DefineProperty('Height', ReadHeight, WriteHeight, True);
end;

destructor TCustomLabeledEdit.Destroy;
begin
  FEdit.Free;
  FEditLabel.Free;
  inherited;
end;

function TCustomLabeledEdit.GetHeight: Integer;
begin
  Result := Round(Size.Height);
end;

function TCustomLabeledEdit.GetLeft: Integer;
begin
  Result := Round(Position.X);
end;

function TCustomLabeledEdit.GetText: string;
begin
  Result := FEdit.Text;
end;

function TCustomLabeledEdit.GetTop: Integer;
begin
  Result := Round(Position.Y);
end;

function TCustomLabeledEdit.GetWidth: Integer;
begin
  Result := Round(Size.Width);
end;

procedure TCustomLabeledEdit.ReadEditLabelCaption(Reader: TReader);
begin
  FEditLabel.Text := Reader.ReadString;
end;

procedure TCustomLabeledEdit.ReadEditLabelHeight(Reader: TReader);
begin
  FEditLabel.Height := Reader.ReadInteger;
end;

procedure TCustomLabeledEdit.ReadEditLabelWidth(Reader: TReader);
begin
  FEditLabel.Width := Reader.ReadInteger;
end;

procedure TCustomLabeledEdit.ReadHeight(Reader: TReader);
begin
  Height := Reader.ReadInteger;
end;

procedure TCustomLabeledEdit.ReadLeft(Reader: TReader);
begin
  Left := Reader.ReadInteger;
end;

procedure TCustomLabeledEdit.ReadTop(Reader: TReader);
begin
  Top := Reader.ReadInteger;
end;

procedure TCustomLabeledEdit.ReadWidth(Reader: TReader);
begin
  Width := Reader.ReadInteger;
end;

function AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
begin
  Result := Alignment;
  if RightToLeftAlignment then
    case Result of
      taLeftJustify: Result := taRightJustify;
      taRightJustify: Result := taLeftJustify;
    end;
end;

procedure TCustomLabeledEdit.RecalculatePosition;
var
  P: TPointF;
  Y: Single;
  UseRightToLeftAlignment: Boolean;
begin
  UseRightToLeftAlignment := False;
  case FLabelPosition of
    lpAbove: begin
      Y := FLabelSpacing; // FEdit.Position.Y - FEditLabel.Height - FLabelSpacing;
      FEdit.Position.X := FLabelSpacing;
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify:  P := PointF(FEdit.Position.X, Y);
        taRightJustify: P := PointF(FEdit.Position.X + Width - FEditLabel.Width, Y);
        taCenter:       P := PointF(FEdit.Position.X + (Width - FEditLabel.Width) / 2, Y);
      end;
      FEdit.Position.Y := Y + FEditLabel.Height + FLabelSpacing;
    end;
    lpBelow: begin
      FEdit.Position.X := FLabelSpacing;
      FEdit.Position.Y := FLabelSpacing;
      Y := FEdit.Position.Y + FEdit.Height + FLabelSpacing;
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify:  P := PointF(FEdit.Position.X, Y);
        taRightJustify: P := PointF(FEdit.Position.X + FEdit.Width - FEditLabel.Width, Y);
        taCenter:       P := PointF(FEdit.Position.X + (FEdit.Width - FEditLabel.Width) / 2, Y);
      end;
    end;
    lpLeft : begin
      FEdit.Position.X := FEditLabel.Width + FLabelSpacing;
      P := PointF(0, FEdit.Position.Y);
    end;
    lpRight: begin
      FEdit.Position.X := 0;
      P := PointF(FEdit.Position.X + FEdit.Width + FLabelSpacing, FEdit.Position.Y);
    end;
  end;
  FEditLabel.SetBounds(P.x, P.y, FEditLabel.Width, FEditLabel.Height);
end;

procedure TCustomLabeledEdit.Resize;
begin
  inherited;
  FEdit.Width := Width - FEditLabel.Width - FLabelSpacing;
end;

procedure TCustomLabeledEdit.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
    begin
      FAlignment := Value;
      RecalculatePosition;
    end;
end;

procedure TCustomLabeledEdit.SetHeight(const Value: Integer);
begin
  Size.Height := Value;
end;

procedure TCustomLabeledEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FEditLabel = nil then Exit;
  if FLabelPosition <> Value then
    begin
      FLabelPosition := Value;
      RecalculatePosition;
    end;
end;

procedure TCustomLabeledEdit.SetLabelSpacing(const Value: Integer);
begin
  if FLabelSpacing <> Value then
    begin
      FLabelSpacing := Value;
      RecalculatePosition;
    end;
end;

procedure TCustomLabeledEdit.SetLeft(const Value: Integer);
begin
  Position.X := Value;
end;

procedure TCustomLabeledEdit.SetText(const Value: string);
begin
  FEdit.Text := Value;
end;

procedure TCustomLabeledEdit.SetTop(const Value: Integer);
begin
  Position.Y := Value;
end;

procedure TCustomLabeledEdit.SetWidth(const Value: Integer);
begin
  Size.Width := Value;
end;

procedure TCustomLabeledEdit.WriteEditLabelCaption(Writer: TWriter);
begin
  Writer.WriteString(FEditLabel.Text);
end;

procedure TCustomLabeledEdit.WriteEditLabelHeight(Writer: TWriter);
begin
  Writer.WriteInteger(Round(FEditLabel.Height));
end;

procedure TCustomLabeledEdit.WriteEditLabelWidth(Writer: TWriter);
begin
  Writer.WriteInteger(Round(FEditLabel.Width));
end;

procedure TCustomLabeledEdit.WriteHeight(Writer: TWriter);
begin
  Writer.WriteInteger(Height);
end;

procedure TCustomLabeledEdit.WriteLeft(Writer: TWriter);
begin
  Writer.WriteInteger(Left);
end;

procedure TCustomLabeledEdit.WriteTop(Writer: TWriter);
begin
  Writer.WriteInteger(Top);
end;

procedure TCustomLabeledEdit.WriteWidth(Writer: TWriter);
begin
  Writer.WriteInteger(Width);
end;

{ TBoundLabel }

constructor TBoundLabel.Create(AOwner: TComponent);
begin
  inherited;
  Name := 'SubLabel';  { do not localize }
  SetSubComponent(True);
  if Assigned(AOwner) then
    Text := AOwner.Name;
end;

procedure TBoundLabel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('FocusControl', nil, nil, False); // Hide FocusControl property
  Filer.DefineProperty('Text', ReadCaption, nil, False);
end;

function TBoundLabel.GetDefaultStyleLookupName: string;
begin
  Result := inherited;
  Result := StringReplace(Result, 'BoundLabel', 'Label', []);
end;

{ TBoundEdit }

procedure TBoundEdit.DefineProperties(Filer: TFiler);
begin
  inherited;
end;

function TBoundEdit.GetDefaultStyleLookupName: string;
begin
  Result := inherited;
  Result := StringReplace(Result, 'BoundEdit', 'Edit', []);
end;

{ TCustomBoundLabel }

procedure TCustomBoundLabel.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Caption', ReadCaption, WriteCaption, True);
end;

function TCustomBoundLabel.GetText: string;
begin
  Result := Text;
end;

procedure TCustomBoundLabel.ReadCaption(Reader: TReader);
begin
  Text := Reader.ReadString;
end;

procedure TCustomBoundLabel.WriteCaption(Writer: TWriter);
begin
  Writer.WriteString(Text);
end;

procedure TCustomBoundLabel.SetText(const Value: string);
begin
  Text := Value;
end;

{ TCheckListBox }

function TCheckListBox.GetDefaultStyleLookupName: string;
begin
  Result := inherited;
  Result := StringReplace(Result, 'CheckListBox', 'GroupBox', []);
end;

end.
