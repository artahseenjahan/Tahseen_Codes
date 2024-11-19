 merge 1:1 cname using "/Users/tahseenjahan/Downloads/qog_std_cs_jan23_stata14.dta"

  su
  count 
  
  tab wdi_lfpf 
  tab rem_gdp
   reg wdi_lfpf rem_gdp
   twoway (scatter wdi_lfpf rem_gdp)
   gen ln_realgdp=log(mad_gdppc)
    gen ln_realgdp2=ln_realgdp^2
	
   
   wdi_gdpcapcur
   
    reg wdi_lfpf rem_gdp gggi_ggi wef_wlf wdi_fertility who_halef  wdi_unempfilo
   
    reg wdi_lfpf rem_gdp ln_realgdp ln_realgdp2 gggi_ggi wef_wlf wdi_fertility who_halef  wdi_unempfilo
	
	reg wdi_lfpf rem_gdp gggi_ggi wef_wlf wdi_fertility who_halef  wdi_unempfilo, vce(robust)
	
	reg wdi_lfpf c.wdi_fertility c.br_dem  c.wdi_fertility#c.br_dem
	
	
