within Absolut.FluidBased.Dynamic.Components.BaseClasses;
model ReferenceData

// Reference data
  Modelica.Units.NonSI.Temperature_degC T[18] = {32.72,32.72,63.61,89.36,53.11,44.96,76.76,40.06,1.39,1.39,
  100,96.51,25,37.03,25,34.65,10,3.64};
  Real Q6 = 0.005 "Vapour quality at point 6";
  Real Q9 = 0.065 "Vapour quality at point 9";
  Real X_LiBr_s = 0.6216 "X_LiBr concentration at strong solution. E.g. point 4";
  Real X_LiBr_w = 0.5648 "X_LiBr concentration at weak solution. E.g. point 1";
  Real h[10](each unit="J/g") = {87.76386,87.76386,149.9,223.3,255,255,2643.1,167.8,167.8,2503.1};
  Modelica.Units.SI.MassFlowRate m_s = 0.05 "Mass flow rate at strong solution. E.g. point 4";
  Modelica.Units.SI.MassFlowRate m_w = 0.04543 "Mass flow rate at weak solution. E.g. point 1";
  parameter Modelica.Units.SI.HeatFlowRate Qcon_ref = 11.31*1000 "Heat flow rate at condenser";
  parameter Modelica.Units.SI.HeatFlowRate Qeva_ref = -10.67*1000 "Heat flow rate at evaporator";
  parameter Modelica.Units.SI.HeatFlowRate Qgen_ref = -14.73*1000 "Heat flow rate at generator";
  parameter Modelica.Units.SI.HeatFlowRate Qabs_ref = 14.09*1000 "Heat flow rate at absorber";
  parameter Modelica.Units.SI.HeatFlowRate Qsol_ref = 3.105*1000 "Heat flow rate at solution heat exchanger";



  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ReferenceData;
