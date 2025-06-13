within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature T "Temperature";
  output Modelica.Units.SI.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := (T - reference_T) * specificHeatCapacityCp(ThermodynamicState(p = 100000, T = T));
  annotation (
    smoothOrder = 5,
    Inline = true,
    derivative = der_enthalpyOfLiquid,
    Documentation(info = "<html>
<p>
This function computes the specific enthalpy of liquid water.
</p>
</html>",
        revisions="<html>
</html>"));
end enthalpyOfLiquid;
