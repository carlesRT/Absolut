within Absolut.Media.LiBrH2O;
function crystallizationtemperature_X
  "Crystallization temperature of the H2O/LiBr solution as a function of X_H2O. Return 0 if not within range."
   //Based on SSC
  input MassFraction X_H2O "Water mass fraction in the solution";
  output Temperature T_cryst "Crystallization temperature";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[3] A_highX = {62.63716, 0.04810823, 0.00024301};
  constant Real[3] A_midX = {56.95202, 0.05205944, 0.00346278};
  constant Real[3] A_lowX = {56.55952, 0.2337275, 0.00141297};
  Real abc[3];
algorithm
  if X_LiBr <= 0.5708 and X_LiBr >= 0.4847 then
    abc := A_lowX;
  elseif X_LiBr <= 0.6505 and X_LiBr > 0.5708 then
    abc := A_midX;
  elseif X_LiBr <= 0.7191 and X_LiBr > 0.6505 then
    abc := A_highX;
  else
  abc := {0,0,0};
  T_cryst := 0;
  end if;

  if abc[2]^2 - 4*(abc[1]-X_LiBr*100)*abc[3] <= 0 then
  abc:= {0,0,0};
  T_cryst := 0;
  else
  T_cryst := 273.15 + (-abc[2] + (abc[2]^2 - 4*(abc[1]-X_LiBr*100)*abc[3])^0.5)/(2*abc[3]);
  end if;

  annotation (Documentation(info="<html>
<p>Notice that hese function is defined within X_LiBr = <span style=\"font-family: Courier New;\">0.4847 </span>and X_LiBr = <span style=\"font-family: Courier New;\">7191</span>.</p>
</html>"));
end crystallizationtemperature_X;
