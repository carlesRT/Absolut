within Absolut.FluidBased.Static.Components.HEX;
model simpleHX
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(use_Q_flow_nominal=false,
    eps_nominal=0.9,
    UA = UA_fix);

  parameter Modelica.Units.SI.ThermalConductance UA_fix=1000
    "Fixed UA value";


equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end simpleHX;
