within Absolut.Media.LiBrH2O.Validation;
model Enthalpy
  extends Modelica.Icons.Example;
  package Medium_l = Modelica.Media.Water.WaterIF97_R1ph
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2ph
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";
  //
  Modelica.Units.SI.Temperature T_eval = combiTimeTable.y[1] + 273.15
    "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_LiBr = combiTimeTable.y[2];

  Modelica.Units.SI.MassFraction X_water= 1 - X_LiBr "Ratio of water";
  Modelica.Units.SI.Pressure p_eval "Pressure in Pascals";

  Real t = time;

   // Check enthalpies ...
   // Comparison with values shown in table 5 in Kaita, 2001: Thermodynamic properties of lithium  bromide-water solutions at high temperaures
  Modelica.Units.SI.SpecificEnthalpy h_kayta;
  Modelica.Units.SI.SpecificEnthalpy h_McNeely;
  Modelica.Units.SI.SpecificEnthalpy h_Feuerecker;
  Modelica.Units.SI.SpecificEnthalpy h_SSC;
  //

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Absolut/Resources/Media/Validation/Enthalpy/KaitaTable6.txt"),
    columns=2:6,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

equation

  p_eval = Medium_sol.saturationPressure_TX(T_eval, X_water);
  h_SSC = Medium_sol.specificEnthalpy_SSC_TXp(T_eval, X_water, p_eval);
  h_kayta = combiTimeTable.y[3] * 1000;
  h_McNeely = combiTimeTable.y[4] * 1000;
  h_Feuerecker = combiTimeTable.y[5] * 1000;

  annotation (__Dymola_Commands(file="modelica://Absolut/Resources/Media/Validation/Enthalpy/KaitaTable6.mos"
        "Simulate and export values",
        file="modelica://Absolut/Resources/Media/Validation/Enthalpy/KaitaTable6_plot.mos"
        "Plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1140,
      Interval=10,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><br>Model for validation purposes. </p>
<p>Comparison&nbsp;with&nbsp;values&nbsp;by&nbsp;Kaita in [1]. Reference data is loaded and compraed to the the implemented SSC functions.</p>
<p>Points for T = 200 &deg;C and X_LiBr = 0.45 and 0.5 are skipped because the functions are not able to find a solution, i.e. simulation stops.</p>
<p><br><b>References:</b></p>
<p>[1] Y. Kaita (2001) Thermodynamic properties of lithium bromide-water solutions at high temperaures, International Journal of Refrigeration 24, 374-390.</p>
</html>"));
end Enthalpy;
