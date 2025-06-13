within Absolut.Media.LiBrH2O.Validation;
model ThorttlingLiBr
  "Desorption of fluid as defined in section 4.8. Using values of example 4.8 of Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  //
  parameter Modelica.Units.SI.Pressure p_in=10000 "Pressure in Pascals (inlet)";
  parameter Modelica.Units.SI.Pressure p_out=1000
    "Pressure in Pascals (outlet)";
  parameter Modelica.Units.SI.MassFraction X_LiBr=0.6;
  Real t = time;

  Modelica.Units.SI.SpecificEnthalpy h_SSC_in[7]
    "Entering streams 1. Leaving stream 2 and 3";
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out[7];
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out_l[7];
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out_v[7] "out";

  parameter Modelica.Units.SI.Temperature T_start_Book[7]={91 + 273.15,90 +
      273.15,80 + 273.15,70 + 273.15,60 + 273.15,50 + 273.15,45 + 273.15}
    "Inflow temperature";
  parameter Modelica.Units.SI.Temperature T_start_LiBr=
      Absolut.Media.LiBrH2O.temperature_Xp(    1 - X_LiBr, p_in)
    "Corresponds to saturation temperature";
  parameter Modelica.Units.SI.Temperature T_start_Water=
      Medium_v.saturationTemperature(p_in)
    "Corresponds to saturation temperature";
  parameter Modelica.Units.SI.Temperature T_out_water=
      Medium_v.saturationTemperature(p_out)
    "Corresponds to saturation temperature";

  Modelica.Units.SI.Temperature T_out[7];
  Modelica.Units.SI.Temperature T_out_correct[7];
  Modelica.Units.SI.MassFraction X_LiBr_out[7](each start=0.6);
  Real Q[7] "Fraction of vapor";
  Real Q_correct[7] "Fraction of vapor";
  Real Q_Book[7] = {0.0288, 0.0281, 0.0217, 0.0154, 0.009, 0.0026, 0} "Fraction of vapor";

equation

for i in 1:7 loop
    h_SSC_in[i] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
      T_start_Book[i],
      1 - X_LiBr,
      p_in);
    h_SSC_in[i] = h_SSC_out[i];
    h_SSC_out_l[i] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
      T_out[i],
      1 - X_LiBr_out[i],
      p_out);
    T_out[i] = Absolut.Media.LiBrH2O.temperature_Xp(1 - X_LiBr_out[i], p_out);

    h_SSC_in[i] = h_SSC_out_l[i]*(1-Q[i]) + Q[i]*h_SSC_out_v[i];

    Q[i] = (X_LiBr_out[i] - X_LiBr) / X_LiBr_out[i];

    h_SSC_out_v[i] = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_out,T_out[i],{1}));

    if Q[i] <= 0 then
      h_SSC_out[i] = Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
        T_out_correct[i],
        1 - X_LiBr_out[i],
        p_out);
      Q_correct[i] = 0;
    else
      T_out_correct[i] = T_out[i];
      Q_correct[i] = Q[i];
    end if;

end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model to test main equations that describe a trohttling valve for LiBr with data of example 4.8 [1].</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Aqueous lithium bromied flows trough a trottling valve. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Inlet and outlet pressure set at 10 an 1 kPa respectively. Solution mass fraction of LiBr is 0.6 at the inlet. The inlet temperature is unknown, a temperature range from the saturation temperature down to suficient subcooling to ensure that the outlet stat is still subcooled is to be tested. The following inlet temperatures in degC are tested: 91, 90, 80, 70, 60, 50 and 45.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Expected leaving temperatures for different entering temperatures according to [1], </span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">49.8 &deg;C (inlet temperature equal to 91 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">49.7 &deg;C (inlet temperature equal to 90 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">48.8 &deg;C (inlet temperature equal to 80 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">47.9 &deg;C (inlet temperature equal to 70 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">47.1 &deg;C (inlet temperature equal to 60 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">46.3 &deg;C (inlet temperature equal to 50 &deg;C)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">45 &deg;C (inlet temperature equal to 45 &deg;C)</span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">References:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</span></p>
</html>"));
end ThorttlingLiBr;
