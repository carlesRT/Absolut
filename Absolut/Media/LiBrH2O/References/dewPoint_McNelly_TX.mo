within Absolut.Media.LiBrH2O.References;
function dewPoint_McNelly_TX
  "Dew point of the LiBr+H2O solution as a function of T and X_LiBr"
  //McNeely, Lowell A. 1979. “Thermodynamic Properties of Aqueous Solutions of Lithium Bromide.”
  input Temperature T "Temperature [K] of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output Temperature D "Dew Point of the LiBr solution = Dew Point of water";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[4] V={-2.00755, 0.16976, -3.13336e-3, 1.97668e-5};
  constant Real[4] W={124.937, -7.7165, 0.152286, -7.9509e-4};
  Modelica.Units.NonSI.Temperature_degC Tc=T - 273.15
    "Temperature [C] of the solution";
  Real[4] X = {(X_LiBr*100)^i for i in 0:3} "Aux. array";
algorithm
  D := 273.15 + (Tc - W*X)/(V*X);
  annotation(derivative=Absolut.Media.LiBrH2O.References.dewPoint_McNelly_TX_der,     inverse(T=Absolut.Media.LiBrH2O.temperature_McNelly_dewPointX));
end dewPoint_McNelly_TX;
