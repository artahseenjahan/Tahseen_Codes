su
count
tab house_type
tab_time
sum cen
gen time_t=2022-time
reg cen time_t
twoway (scatter cen time)
reg gcapf_usd cen
gen lngcapf_usd=log(gcapf_usd)
reg lngcapf_usd cen

tab elec_sys,gen(elec_sysdum)
reg lngcapf_usd cen elec_sysdum4
reg lngcapf_usd elec_sysdum4

gen lngnexp_usd=log(gnexp_usd)
reg lngnexp_usd cen

 gen lngsav_usd=log(gsav_usd)
 reg lngnexp_usd cen lngsav_usd
 
  reg revenue_percgdp cen
  
 ed if country=="Bangladesh"

reg revenue_percgdp time_t

 su gini mulpov_headrat_undp mulpov_headrat_wb
  reg mulpov_headrat_wb cen
  
  reg gini cen
  
   ipolate gcapf_usd time, gen(new_gcapf_usd) epolate by (country)
    gen lnnewgcapf_usd=log(new_gcapf_usd)
	reg lnnewgcapf_usd time_t
	
Day 2
destring obs_no  win_seats total_seats cen gsav_usd net_fdi_usd gcapf_usd net_devaid_usd goveff_percrank goveff_esti gnexp_usd exp_gs_usd stocks_trat_usd mcap_comp_usd revenue_percgdp san_percpop mortality_sanrate mortality_5rate educ_lsec_totalperc unpaid_fem_perc24h women_3dec_perc livbelow_50perc_midinc mulpov_headrat_undp mulpov_headrat_wb livbelow_5meters_perc gini inc_share_top10 povheadrat_nlines, replace force 

reg gcapf_usd cen
    ipolate gcapf_usd time, gen(new_gcapf_usd) epolate by (country)
     gen lnnewgcapf_usd=log(new_gcapf_usd) 

reg lnnewgcapf_usd cen

   ipolate gsav_usd time, gen(new_gsav_usd) epolate by (country)
    gen lnnew_gsav_usd=log(new_gsav_usd)
	
reg lnnewgcapf_usd cen lnnew_gsav_usd
   
   ipolate gnexp_usd time, gen(new_gnexp_usd) epolate by (country)
    gen lnnewgnexp_usd=log(new_gnexp_usd)
	
reg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd

  ipolate net_fdi_usd time, gen(new_net_fdi_usd) epolate by (country)
   gen lnnewnet_fdi_usd=log(new_net_fdi_usd)
   
reg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd lnnewnet_fdi_usd

    ipolate revenue_percgdp time, gen(new_revenue_percgdp) epolate by (country)
    gen lnnewrevenue_percgdp=log(new_revenue_percgdp)
reg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd lnnewnet_fdi_usd lnnewrevenue_percgdp

reg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd lnnewnet_fdi_usd
egen cid= group(country)

Panel:
xtset cid time

 xtreg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd lnnewnet_fdi_usd, fe
 estimate store fe
 xtreg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd lnnewnet_fdi_usd, re 
estimate store re
   hausman fe re
  xtreg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd, fe
  tab country,gen(cdum)
xtreg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd cdum1-cdum30, fe

xtreg lnnewgcapf_usd cen lnnew_gsav_usd lnnewgnexp_usd cdum1-cdum30, re
 twoway (scatter lnnewgcapf_usd lnnew_gsav_usd)

twoway (scatter lnnewgcapf_usd lnnew_gsav_usd)
twoway (scatter lnnewgcapf_usd cen)
twoway (scatter lnnew_gsav_usd cen)
twoway (scatter lnnewgnexp_usd cen)

 xtreg cen cdum1-cdum30 time
 
   xtreg cen lnnewgnexp_usd cdum1-cdum30
    predict cenhat
	 xtreg lnnewgcapf_usd cenhat lnnew_gsav_usd
    xtreg lnnewgcapf_usd cenhat lnnew_gsav_usd, fe - ipolate
	xtreg lngcapf_usd cen lngsav_usd lngnexp_usd, fe -No ipolate
	xtreg lngcapf_usd cen, fe- No ipolate
	
Inequality:
 ipolate gini time, gen(new_gini) epolate by (country)
  ipolate inc_share_top10  time, gen(new_inc_share_top10) epolate by (country)
  ipolate livbelow_50perc_midinc  time, gen(new_livbelow_50perc_midinc) epolate by (country)
  xtreg new_gini cen new_inc_share_top10 new_livbelow_50perc_midinc
   xtreg new_gini cen new_inc_share_top10 new_livbelow_50perc_midinc, fe
     xtreg cen new_inc_share_top10 cdum1-cdum30
	 
twoway (scatter  new_gini new_inc_share_top10 )
twoway (scatter  new_gini new_livbelow_50perc_midinc )
 xtreg new_gini cenhat new_inc_share_top10 new_livbelow_50perc_midinc, fe -INSIGNIFICANT Cen
xtreg gini cenhat inc_share_top10 if country=="Bangladesh", fe
 gen cdumcen= cdum3*cenhat
  
	 xtreg gini cenhat inc_share_top10 livbelow_50perc_midinc mortality_5rate, fe
	  xtreg gini cenhat inc_share_top10 livbelow_50perc_midinc mortality_5rate cdumcen, fe
 xtreg new_gini cen, fe
  xtreg lnnewgcapf_usd cen, fe
  
   line cen time, by(country) legend(off)
   
   Graph
   gen time_category = .
replace time_category = 1 if time >= 1960 & time <= 1989
replace time_category = 2 if time >= 1990 & time <= 2009 
replace time_category = 3 if time >= 2010 & time <= 2022

gen south_asia = 0
replace south_asia = 1 if country == "India" | country == "Bangladesh"

label define time_category_label 1 "1960-1989" 2 "1990-2009" 3 "2010-2022"
label values time_category time_category_label

label define south_asia_label 0 "Europe" 1 "Asia"
label values south_asia south_asia_label

graph bar cen, over(south_asia) over(time_category)
keep if time_category == 3
graph bar (mean) cen, over(country)



