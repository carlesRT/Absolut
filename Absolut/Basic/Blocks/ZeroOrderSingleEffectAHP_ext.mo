within Absolut.Basic.Blocks;
model ZeroOrderSingleEffectAHP_ext
  "Zero order model of a single effect Absorption heat pump with external fluids"

  //parameter Boolean use_Te=false "false to use T_c instead";

  Modelica.Units.SI.Temperature Te(start = Tei_start + 1) "Low temperature level";
  Modelica.Blocks.Interfaces.RealInput Th(unit="K") "High temperature level" annotation (Placement(transformation(
          extent={{-100,60},{-60,100}}), iconTransformation(extent={{-100,60},{-60,
            100}})));
  Modelica.Blocks.Interfaces.RealInput Tc(unit="K")
    "Intermediate temperature level" annotation (Placement(transformation(
          extent={{-100,-20},{-60,20}}), iconTransformation(extent={{-100,-20},{
            -60,20}})));

  Modelica.Blocks.Interfaces.RealOutput COP "Heating COP" annotation (Placement(
        transformation(extent={{80,-60},{100,-40}}), iconTransformation(extent={
            {80,-10},{100,10}})));
  Modelica.Blocks.Interfaces.RealOutput EER "Cooling COP" annotation (Placement(transformation(
          extent={{80,40},{100,60}}),  iconTransformation(extent={{80,40},{100,60}})));

  parameter Modelica.Units.SI.ThermalConductance UAe = 500 "UA Value: Overall heat transfer coefficient times area at the evaporator";
  parameter Modelica.Units.SI.ThermalConductance UAc = UAe "UA Value: Overall heat transfer coefficient times area at the absorber and condenser";
  parameter Modelica.Units.SI.ThermalConductance UAh = UAe "UA Value: Overall heat transfer coefficient times area at the generator";

  Modelica.Units.SI.TemperatureDifference dTe(min=0) "Temperature difference between internal and external temperatures at evaporator";
  Modelica.Units.SI.TemperatureDifference dTc(min=0) "Temperature difference between internal and external temperatures at condenser and absorber";
  parameter Modelica.Units.SI.TemperatureDifference dTh = 10 "Prescribed temperature difference between internal and external temperatures at generator";

  Modelica.Units.SI.Temperature Tei(start = Tei_start), Tci(start = Tci_start),Thi(start = Thi_start) "Internal temperatures";

  Modelica.Units.SI.HeatFlowRate Qc(max=0) "Overall heat flow rate at condenser and absorber";
  Modelica.Units.SI.HeatFlowRate Qe(min=0) "Heat flow rate at evaporator";
  Modelica.Units.SI.HeatFlowRate Qh(min=0) "Heat flow rate at generator";

  parameter Modelica.Units.SI.Temperature Tei_start = 285.15;
  parameter Modelica.Units.SI.Temperature Tci_start = 300.15;
  parameter Modelica.Units.SI.Temperature Thi_start = 350.15;

equation
  Tei = Te - dTe;
  Tci = Tc + dTc;
  Thi = Th - dTh;

  Qe = UAe * (Te - Tei);
  Qc = UAc * (Tci - Tc);
  Qh = UAh * (Th - Thi);

  Qc = Qh + Qe;

  Thi - Tci = Tci - Tei;

  Qe / Qh = (Tei/Thi);

  COP = Qc / Qh;
  EER = Qe / Qh;

//assert(Tei >= 273.15, "Temperature at evaporator is below 0°C", level = AssertionLevel.warning);

  annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}));
end ZeroOrderSingleEffectAHP_ext;
