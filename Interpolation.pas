unit Interpolation;

interface

uses IntervalArithmetic;
  
type TExtendedArray = array of Extended;
type TIntervalArray = array of interval;

function Lagrange( degree : Integer;
                   nodes  : TExtendedArray;
                   values : TExtendedArray;
                   point  : Extended;
                   var status : Integer) : Extended; overload;

function LagrangeCoefficients( degree : Integer;
                   nodes  : TExtendedArray;
                   values : TExtendedArray;
                   var status : Integer) : TExtendedArray; overload;

function Lagrange( degree : Integer;
                   nodes  : TIntervalArray;
                   values : TIntervalArray;
                   point  : Interval;
                   var status : Integer) : Interval; overload;

function LagrangeCoefficients( degree : Integer;
                   nodes  : TIntervalArray;
                   values : TIntervalArray;
                   var status : Integer) : TIntervalArray; overload;

function Neville( degree : Integer;
                  nodes  : TExtendedArray;
                  values : TExtendedArray;
                  point  : Extended;
                  var status : Integer) : Extended; overload;

function Neville( degree : Integer;
                  nodes  : TIntervalArray;
                  values : TIntervalArray;
                  point  : Interval;
                  var status : Integer) : Interval; overload;

implementation

function Lagrange (degree : Integer;
                   nodes  : TExtendedArray;
                   values : TExtendedArray;
                   point  : Extended;
                   var status : Integer) : Extended;
var i,k  : Integer;
    fx,p : Extended;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if nodes[i]=nodes[k]
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    fx:=0;
                    for i:=0 to degree do
                      begin
                        p:=1;
                        for k:=0 to degree do
                          if k<>i
                            then p:=p*(point-nodes[k])/(nodes[i]-nodes[k]);
                        fx:=fx+values[i]*p
                      end;
                    Lagrange:=fx
                  end
         end
end;

function LagrangeCoefficients (degree : Integer;
                   nodes  : TExtendedArray;
                   values : TExtendedArray;
                   var status : Integer) : TExtendedArray; overload;
var i,k,l: Integer;
    p : Extended;
    cfs  : TExtendedArray;
    poly : TExtendedArray;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if nodes[i]=nodes[k]
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    SetLength(cfs, degree+1);
                    SetLength(poly, degree+1);
                    SetLength(result, degree+1);
                    for i := 0 to degree do
                      result[i] := 0;
                    for i:=0 to degree do
                      begin
                        p:=1;
                        for k:=0 to degree do
                          if k<>i
                            then p:=p*(nodes[i]-nodes[k]);
                        cfs[i] := values[i]/p;
                      end;
                    for i := 0 to degree do begin
                      for l := 0 to degree do
                        poly[l] := 0;
                      poly[degree] := 1;
                      for l := 0 to degree do
                        if i <> l then
                          for k := 0 to degree-1 do
                            poly[k] := poly[k] - poly[k+1]*nodes[l];
                      for l := 0 to degree do begin
                        poly[l] := poly[l]*cfs[i];;
                        result[l] := result[l] + poly[l];
                      end;
                    end;
                  end
         end
end;

function LagrangeCoefficients (degree : Integer;
                   nodes  : TIntervalArray;
                   values : TIntervalArray;
                   var status : Integer) : TIntervalArray; overload;
var i,k,l: Integer;
    fx,p : Interval;
    cfs  : TIntervalArray;
    poly : TIntervalArray;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if iequal(nodes[i], nodes[k])
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    SetLength(cfs, degree+1);
                    SetLength(poly, degree+1);
                    SetLength(result, degree+1);
                    for i := 0 to degree do
                      result[i] := izero;
                    fx:=izero;
                    for i:=0 to degree do
                      begin
                        p:=ione;
                        for k:=0 to degree do
                          if k<>i
                            then p:=imul(p, isub(nodes[i], nodes[k]));
                        cfs[i] := idiv(values[i], p);
                      end;
                    for i := 0 to degree do begin
                      for l := 0 to degree do
                        poly[l] := izero;
                      poly[degree] := ione;
                      for l := 0 to degree do
                        if i <> l then
                          for k := 0 to degree-1 do
                            poly[k] := isub(poly[k], imul(poly[k+1],nodes[l]));
                      for l := 0 to degree do begin
                        poly[l] := imul(poly[l],cfs[i]);
                        result[l] := iadd(result[l], poly[l]);
                      end;
                    end;
                  end
         end
end;


function Lagrange( degree : Integer;
                   nodes  : TIntervalArray;
                   values : TIntervalArray;
                   point  : interval;
                   var status : Integer) : interval;
var i,k  : Integer;
    fx,p : Interval;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if iequal(nodes[i], nodes[k])
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    fx:=izero;
                    for i:=0 to degree do
                      begin
                        p:=ione;
                        for k:=0 to degree do
                          if k<>i
                            then p:=imul(p, idiv((isub(point, nodes[k])), (isub(nodes[i], nodes[k]))));
                        fx:=iadd(fx, imul(values[i], p))
                      end;
                    Lagrange:=fx
                  end
         end
end;

function Neville (degree : Integer;
                  nodes  : TExtendedArray;
                  values : TExtendedArray;
                  point  : Extended;
                  var status : Integer) : Extended;
var i,k : Integer;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if nodes[i]=nodes[k]
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    for k:=1 to degree do
                      for i:=degree downto k do
                        values[i]:=((point-nodes[i-k])*values[i]-(point-nodes[i])*values[i-1])
                              /(nodes[i]-nodes[i-k]);
                    Neville:=values[degree]
                  end
         end
end;

function Neville( degree : Integer;
                  nodes  : TIntervalArray;
                  values : TIntervalArray;
                  point  : Interval;
                  var status : Integer) : Interval;
var i,k : Integer;
begin
  if degree<0
    then status:=1
    else begin
           status:=0;
           if degree>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for k:=i+1 to degree do
                        if iequal(nodes[i], nodes[k])
                          then status:=2
                    until (i=degree-1) or (status=2)
                  end;
           if status=0
             then begin
                    for k:=1 to degree do
                      for i:=degree downto k do
                        values[i]:=idiv(isub(imul(isub(point, nodes[i-k]), values[i]), imul(isub(point,nodes[i]), values[i-1]))
                              ,isub(nodes[i],nodes[i-k]));
                    Neville:=values[degree]
                  end
         end
end;
end.
