within Absolut.Media.LiBrH2O.Validation;
model Density
   extends Modelica.Icons.Example;
   package Medium = Absolut.Media.LiBrH2O
    "Solution medium";

  Modelica.Units.SI.Density rho[5];
  Modelica.Units.SI.Temperature T[5];
  Modelica.Units.SI.Temperature Tdata=combiTimeTable.y[1];
  //Modelica.SIunits.Temperature T( start=293) = 323 + 1*time;
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Absolut/Resources/Media/Validation/Density/Density.txt"),
    columns=2:7)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

parameter Real X_LiBr[5] = {0.3,0.4,0.5,0.6,0.65};
  parameter Modelica.Units.SI.Temperature T_min[5]={278,283,294,311,323};
  parameter Modelica.Units.SI.Temperature T_max[5]={442,453,471,495,509};

equation
    T[1] = min(T_max[1],max(T_min[1],Tdata));
    rho[1] = Medium.density(Medium.setState_pTX(Medium.saturationPressure_TX(T[1],1-X_LiBr[1]),T[1],{1-X_LiBr[1]}));
    T[2] = min(T_max[2],max(T_min[2],Tdata));
    rho[2] = Medium.density(Medium.setState_pTX(Medium.saturationPressure_TX(T[2],1-X_LiBr[2]),T[2],{1-X_LiBr[2]}));
    T[3] = min(T_max[3],max(T_min[3],Tdata));
    rho[3] = Medium.density(Medium.setState_pTX(Medium.saturationPressure_TX(T[3],1-X_LiBr[3]),T[3],{1-X_LiBr[3]}));
    T[4] = min(T_max[4],max(T_min[4],Tdata));
    rho[4] = Medium.density(Medium.setState_pTX(Medium.saturationPressure_TX(T[4],1-X_LiBr[4]),T[4],{1-X_LiBr[4]}));
    T[5] = min(T_max[5],max(T_min[5],Tdata));
    rho[5] = Medium.density(Medium.setState_pTX(Medium.saturationPressure_TX(T[5],1-X_LiBr[5]),T[5],{1-X_LiBr[5]}));

  annotation (
 __Dymola_Commands(file="modelica://Absolut/Resources/Media/Validation/Density/Density.mos"
        "Simulate and export values"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=250,
      Interval=0.1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><br>Model for validation purposes. </p>
<p>Comparison&nbsp;with&nbsp;values&nbsp;by&nbsp;S.V. Stankus et.al. in [1]. Reference data is loaded and compared to the the implemented SSC functions.</p>
<p><br><b>References:</b></p>
<p>[1] S.V. Stankus (2007) The Density of Aqueous Solutions of Lithium Bromide at High Temperatures and Concentrations. Vol. 45, No. 3. DOI: 10.1134/S0018151X07030212</p>
</html>"));
end Density;
