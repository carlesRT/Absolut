within Absolut.Media.LiBrH2O.Utilities;
function cristalitzation_TX
  "Returns a boolean. Check if cristalitzation occurs."
  input Modelica.Units.SI.Temperature T "Solution temperature";
  input Modelica.Units.SI.MassFraction X_H2O "Water mass fraction in solution";
  output Real cris "1 if cristalitzation occurs";

algorithm
  if 1 - X_H2O > 0.7191 then
  cris := 0;
  else
    if Absolut.Media.LiBrH2O.crystallizationtemperature_X(X_H2O) > T then
      cris := 1;
    else
      cris := 0;
    end if;
  end if;

end cristalitzation_TX;
