within Absolut.Media.LiBrH2O.Validation;
model ThorttlingWater
  "Desorption of fluid as defined in section 4.8. Using values of example 4.7 of Herold's book"
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";

//
  parameter Modelica.Units.SI.Pressure p_in=10000 "Pressure in Pascals";
  parameter Modelica.Units.SI.Pressure p_out=1000 "Pressure in Pascals";
  Real t = time;

  Modelica.Units.SI.SpecificEnthalpy h_SSC_in[6]
    "Entering streams 1. Leaving stream 2 and 3";
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out[6];
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out_v;
  Modelica.Units.SI.SpecificEnthalpy h_SSC_out_l "out";

  parameter Modelica.Units.SI.Temperature T_start_Book[6]={45.817 + 273.15,45
       + 273.15,35 + 273.15,25 + 273.15,15 + 273.15,5 + 273.15}
    "Inflow temperature";
  parameter Modelica.Units.SI.Temperature T_start_Water_sat=
      Medium_v.saturationTemperature(p_in)
    "Corresponds to saturation temperature";
  Modelica.Units.SI.Temperature T_end_Water;
  Modelica.Units.SI.Temperature T_end_Water_correct[6];
  Modelica.Units.SI.Temperature T_end_Water_sat=Medium_v.saturationTemperature(
      p_out) "Corresponds to saturation temperature";
  Modelica.Units.SI.Temperature T_end_Book[6]={6.97 + 273.15,6.97 + 273.15,6.97
       + 273.15,6.97 + 273.15,6.97 + 273.15,5.002 + 273.15};

  Real Q[6], Q_correct[6] "Fraction of vapor";
  Real Q_Book[6] = {0.065, 0.064, 0.047, 0.03, 0.014, 0} "Fraction of vapor";

equation

for i in 1:6 loop
    h_SSC_in[i] = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_in,T_start_Book[i],{1}));
    h_SSC_in[i] = h_SSC_out[i];
    h_SSC_in[i] = h_SSC_out_l*(1-Q[i]) + Q[i]*h_SSC_out_v;
    if Q[i] <= 0 then
      h_SSC_out[i] = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_out,T_end_Water_correct[i],{1}));
      Q_correct[i] = 0;
    else
      T_end_Water_correct[i] = T_end_Water;
      Q_correct[i] = Q[i];
    end if;
end for;
    T_end_Water = T_end_Water_sat;
    h_SSC_out_l = Medium_l.specificEnthalpy(Medium_l.setState_pTX(p_out,T_end_Water,{1}));
    h_SSC_out_v = Medium_v.specificEnthalpy(Medium_v.setState_pTX(p_out,T_end_Water,{1}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=16,
      Interval=0.1,
      Tolerance=1e-09),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Testing main equations to describe a trohttling valve for water with data of example 4.7 of Herold&apos;s book.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Liquid water flows trough a trottling valve. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Inlet and outlet pressure set at 10 an 1 kPa respectively. The inlet temperature is unknown, a temperature range from the saturation temperature down to suficient subcooling to ensure that the outlet stat is still subcooled is to be tested. The following inlet temperatures in degC are tested: 45.817, 45, 35, 25, 15 and 5.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Expected leaving temperatures for different entering temperatures according to [1], </span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">6.97 &deg;C (inlet temperature equal to 45.817, 45, 35, 25 and 15 &deg;C. Q Fraction equal to 0.065, 0.064, 0.047, 0.03, and 0.014 respectively)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">5.002 &deg;C (inlet temperature equal to 5 &deg;C. Q Fraction equal to zero)</span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">References:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</span></p>
</html>"));
end ThorttlingWater;
