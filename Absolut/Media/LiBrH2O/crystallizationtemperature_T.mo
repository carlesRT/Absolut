within Absolut.Media.LiBrH2O;
function crystallizationtemperature_T
  "Crystallization temperature of the H2O/LiBr solution as a function of T."
   //Based on SSC
  input Temperature T "Temperature of the solution";
  output MassFraction X_LiBr "LiBr mass fraction in the solution";

protected
  constant Real[3] A_highX = {62.63716, 0.04810823, 0.00024301} "A0, A1, A2";
  constant Real[3] A_midX = {56.95202, 0.05205944, 0.00346278} "A0, A1, A2";
  constant Real[3] A_lowX = {56.55952, 0.2337275, 0.00141297} "A0, A1, A2";
  Real[3] T_ = {1,(T-273.15),(T-273.15)^2} "Aux. array";
  Real abc[3];
algorithm

  if T <= 120.005+273.15 and T >= 41.5186+273.15 then
    abc := A_highX;
  elseif T <= 41.5186+273.15 and T > 2.19766+273.15 then
    abc := A_midX;
  elseif T <= 2.19766+273.15 and T > 273.15 - 49 then
    abc := A_lowX;
  else
  abc := {0,0,0};
  end if;

  X_LiBr := abc*T_/100;

  annotation (Documentation(info="<html>
<p>The function for the cristalization is defined as a second degree polynomial, see below. The function is obtained from [1]. </p>
<p><img src=\"modelica://Absolut/Resources/Images/equations/equation-2PFo6qLO.png\" alt=\"x = A0+A1*T+A2*T^2\"/></p>
<p>Notice that hese function is defined within X_LiBr = 0.4847 and X_LiBr = 0.7191.</p>
<p><br><br><b>Sources:</b></p>
<p>[1] LiBrSSC (aquous lithium bromide) Property Routines. <a href=\"https://fchart.com/ees/libr_help/ssclibr.pdf\">https://fchart.com/ees/libr_help/ssclibr.pdf</a></p>
</html>"));
end crystallizationtemperature_T;
