within Absolut.FluidBased.Static.Components.HEX;
model ConstantEffectiveness

    parameter Modelica.Units.SI.ThermalConductance UA_fix=0
    "Dummy value. Added to ease redeclaration.";

  extends Buildings.Fluid.HeatExchangers.ConstantEffectiveness;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConstantEffectiveness;
