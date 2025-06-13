within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
function specificHeatCapacityCp_ext "Return the specific heat capacity at constant pressure"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output SpecificHeatCapacity cp "Specific heat capacity at constant pressure";
protected
  parameter Real c[2] = {0.63494688, 0.00334662};
algorithm
  cp := 1000 * (c[1] + (state.T)*c[2]);
  annotation (
    Inline = true,
    derivative = der_specificHeatCapacityCp_ext,
    Documentation(info = "<html>
<p>
This function returns the specific heat capacity at constant pressure.
</p>
</html>",
        revisions="<html>

</html>"));
end specificHeatCapacityCp_ext;
