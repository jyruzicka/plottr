require "plottr"

# Data from CIA World Factbook
# https://www.cia.gov/library/publications/the-world-factbook
# Data retrieved 2017-01-03

module Plottr::Data
  def self.population
    @population ||= begin
      t = Plottr::Table.new(Country: :string, Population: :number, Area: :number)
      t << {Country: "China", Population: 1_373_541_278, Area: 9_596_960}
      t << {Country: "India", Population: 1_266_883_598, Area: 3_287_263}
      t << {Country: "United States", Population: 323_995_528, Area: 9_826_675}
      t << {Country: "Indonesia", Population: 258_316_051, Area: 1_904_569}
      t << {Country: "Brazil", Population: 205_823_665, Area: 8_514_877}
      t << {Country: "Pakistan", Population: 201_995_540, Area: 796_095}
      t << {Country: "Nigeria", Population: 186_053_386, Area: 923_768}
      t << {Country: "Bangladesh", Population: 156_186_882, Area: 143_998}
      t << {Country: "Russia", Population: 142_355_415, Area: 17_098_242}
      t << {Country: "Japan", Population: 126_702_133, Area: 377_915}
      t << {Country: "Mexico", Population: 123_166_749, Area: 1_964_375}
      t << {Country: "Philippines", Population: 102_624_209, Area: 300_000}
      t << {Country: "Ethiopia", Population: 102_374_044, Area: 1_104_300}
      t << {Country: "Vietnam", Population: 95_261_021, Area: 331_210}
      t << {Country: "Egypt", Population: 94_666_993, Area: 1_001_450}
      t << {Country: "Iran", Population: 82_801_633, Area: 1_648_195}
      t << {Country: "Congo, Democratic Republic of the", Population: 81_331_050, Area: 2_344_858}
      t << {Country: "Germany", Population: 80_722_792, Area: 357_022}
      t << {Country: "Turkey", Population: 80_274_604, Area: 783_562}
      t << {Country: "Thailand", Population: 68_200_824, Area: 513_120}
      t << {Country: "France", Population: 66_836_154, Area: 643_801}
      t << {Country: "United Kingdom", Population: 64_430_428, Area: 243_610}
      t << {Country: "Italy", Population: 62_007_540, Area: 301_340}
      t << {Country: "Burma", Population: 56_890_418, Area: 676_578}
      t << {Country: "South Africa", Population: 54_300_704, Area: 1_219_090}
      t << {Country: "Tanzania", Population: 52_482_726, Area: 947_300}
      t << {Country: "Korea, South", Population: 50_924_172, Area: 99_720}
      t << {Country: "Spain", Population: 48_563_476, Area: 505_370}
      t << {Country: "Colombia", Population: 47_220_856, Area: 1_138_910}
      t << {Country: "Kenya", Population: 46_790_758, Area: 580_367}
      t << {Country: "Ukraine", Population: 44_209_733, Area: 603_550}
      t << {Country: "Argentina", Population: 43_886_748, Area: 2_780_400}
      t << {Country: "Algeria", Population: 40_263_711, Area: 2_381_741}
      t << {Country: "Poland", Population: 38_523_261, Area: 312_685}
      t << {Country: "Uganda", Population: 38_319_241, Area: 241_038}
      t << {Country: "Iraq", Population: 38_146_025, Area: 438_317}
      t << {Country: "Sudan", Population: 36_729_501, Area: 1_861_484}
      t << {Country: "Canada", Population: 35_362_905, Area: 9_984_670}
      t << {Country: "Morocco", Population: 33_655_786, Area: 446_550}
      t << {Country: "Afghanistan", Population: 33_332_025, Area: 652_230}
      t << {Country: "Malaysia", Population: 30_949_962, Area: 329_847}
      t << {Country: "Venezuela", Population: 30_912_302, Area: 912_050}
      t << {Country: "Peru", Population: 30_741_062, Area: 1_285_216}
      t << {Country: "Uzbekistan", Population: 29_473_614, Area: 447_400}
      t << {Country: "Nepal", Population: 29_033_914, Area: 147_181}
      t << {Country: "Saudi Arabia", Population: 28_160_273, Area: 2_149_690}
      t << {Country: "Yemen", Population: 27_392_779, Area: 527_968}
      t << {Country: "Ghana", Population: 26_908_262, Area: 238_533}
      t << {Country: "Mozambique", Population: 25_930_150, Area: 799_380}
      t << {Country: "Korea, North", Population: 25_115_311, Area: 120_538}
      t << {Country: "Madagascar", Population: 24_430_325, Area: 587_041}
      t << {Country: "Cameroon", Population: 24_360_803, Area: 475_440}
      t << {Country: "Cote d'Ivoire", Population: 23_740_424, Area: 322_463}
      t << {Country: "Taiwan", Population: 23_464_787, Area: 35_980}
      t << {Country: "Australia", Population: 22_992_654, Area: 7_741_220}
      t << {Country: "Sri Lanka", Population: 22_235_000, Area: 65_610}
      t << {Country: "Romania", Population: 21_599_736, Area: 238_391}
      t << {Country: "Angola", Population: 20_172_332, Area: 1_246_700}
      t << {Country: "Burkina Faso", Population: 19_512_533, Area: 274_200}
      t << {Country: "Niger", Population: 18_638_600, Area: 1_267_000}
      t << {Country: "Malawi", Population: 18_570_321, Area: 118_484}
      t << {Country: "Kazakhstan", Population: 18_360_353, Area: 2_724_900}
      t << {Country: "Chile", Population: 17_650_114, Area: 756_102}
      t << {Country: "Mali", Population: 17_467_108, Area: 1_240_192}
      t << {Country: "Syria", Population: 17_185_170, Area: 185_180}
      t << {Country: "Netherlands", Population: 17_016_967, Area: 41_543}
      t << {Country: "Ecuador", Population: 16_080_778, Area: 283_561}
      t << {Country: "Cambodia", Population: 15_957_223, Area: 181_035}
      t << {Country: "Zambia", Population: 15_510_711, Area: 752_618}
      t << {Country: "Guatemala", Population: 15_189_958, Area: 108_889}
      t << {Country: "Zimbabwe", Population: 14_546_961, Area: 390_757}
      t << {Country: "Senegal", Population: 14_320_055, Area: 196_722}
      t << {Country: "Rwanda", Population: 12_988_423, Area: 26_338}
      t << {Country: "South Sudan", Population: 12_530_717, Area: 644_329}
      t << {Country: "Guinea", Population: 12_093_349, Area: 245_857}
      t << {Country: "Chad", Population: 11_852_462, Area: 1_284_000}
      t << {Country: "Belgium", Population: 11_409_077, Area: 30_528}
      t << {Country: "Cuba", Population: 11_179_995, Area: 110_860}
      t << {Country: "Tunisia", Population: 11_134_588, Area: 163_610}
      t << {Country: "Burundi", Population: 11_099_298, Area: 27_830}
      t << {Country: "Bolivia", Population: 10_969_649, Area: 1_098_581}
      t << {Country: "Portugal", Population: 10_833_816, Area: 92_090}
      t << {Country: "Somalia", Population: 10_817_354, Area: 637_657}
      t << {Country: "Greece", Population: 10_773_253, Area: 131_957}
      t << {Country: "Benin", Population: 10_741_458, Area: 112_622}
      t << {Country: "Czechia", Population: 10_644_842, Area: 78_867}
      t << {Country: "Dominican Republic", Population: 10_606_865, Area: 48_670}
      t << {Country: "Haiti", Population: 10_485_800, Area: 27_750}
      t << {Country: "Sweden", Population: 9_880_604, Area: 450_295}
      t << {Country: "Hungary", Population: 9_874_784, Area: 93_028}
      t << {Country: "Azerbaijan", Population: 9_872_765, Area: 86_600}
      t << {Country: "Belarus", Population: 9_570_376, Area: 207_600}
      t << {Country: "Honduras", Population: 8_893_259, Area: 112_090}
      t << {Country: "Austria", Population: 8_711_770, Area: 83_871}
      t << {Country: "Tajikistan", Population: 8_330_946, Area: 143_100}
      t << {Country: "Jordan", Population: 8_185_384, Area: 89_342}
      t << {Country: "Switzerland", Population: 8_179_294, Area: 41_277}
      t << {Country: "Israel", Population: 8_174_527, Area: 20_770}
      t << {Country: "Togo", Population: 7_756_937, Area: 56_785}
      t << {Country: "Hong Kong", Population: 7_167_403, Area: 1_108}
      t << {Country: "Bulgaria", Population: 7_144_653, Area: 110_879}
      t << {Country: "Serbia", Population: 7_143_921, Area: 77_474}
      t << {Country: "Laos", Population: 7_019_073, Area: 236_800}
      t << {Country: "Paraguay", Population: 6_862_812, Area: 406_752}
      t << {Country: "Papua New Guinea", Population: 6_791_317, Area: 462_840}
      t << {Country: "Libya", Population: 6_541_948, Area: 1_759_540}
      t << {Country: "Lebanon", Population: 6_237_738, Area: 10_400}
      t << {Country: "El Salvador", Population: 6_156_670, Area: 21_041}
      t << {Country: "Sierra Leone", Population: 6_018_888, Area: 71_740}
      t << {Country: "Nicaragua", Population: 5_966_798, Area: 130_370}
      t << {Country: "United Arab Emirates", Population: 5_927_482, Area: 83_600}
      t << {Country: "Eritrea", Population: 5_869_869, Area: 117_600}
      t << {Country: "Singapore", Population: 5_781_728, Area: 697}
      t << {Country: "Kyrgyzstan", Population: 5_727_553, Area: 199_951}
      t << {Country: "Denmark", Population: 5_593_785, Area: 43_094}
      t << {Country: "Central African Republic", Population: 5_507_257, Area: 622_984}
      t << {Country: "Finland", Population: 5_498_211, Area: 338_145}
      t << {Country: "Slovakia", Population: 5_445_802, Area: 49_035}
      t << {Country: "Turkmenistan", Population: 5_291_317, Area: 488_100}
      t << {Country: "Norway", Population: 5_265_158, Area: 323_802}
      t << {Country: "Ireland", Population: 4_952_473, Area: 70_273}
      t << {Country: "Georgia", Population: 4_928_052, Area: 69_700}
      t << {Country: "Costa Rica", Population: 4_872_543, Area: 51_100}
      t << {Country: "Congo, Republic of the", Population: 4_852_412, Area: 342_000}
      t << {Country: "New Zealand", Population: 4_474_549, Area: 267_710}
      t << {Country: "Croatia", Population: 4_313_707, Area: 56_594}
      t << {Country: "Liberia", Population: 4_299_944, Area: 111_369}
      t << {Country: "Bosnia and Herzegovina", Population: 3_861_912, Area: 51_197}
      t << {Country: "Panama", Population: 3_705_246, Area: 75_420}
      t << {Country: "Mauritania", Population: 3_677_293, Area: 1_030_700}
      t << {Country: "Puerto Rico", Population: 3_578_056, Area: 13_790}
      t << {Country: "Moldova", Population: 3_510_485, Area: 33_851}
      t << {Country: "Oman", Population: 3_355_262, Area: 309_500}
      t << {Country: "Uruguay", Population: 3_351_016, Area: 176_215}
      t << {Country: "Armenia", Population: 3_051_250, Area: 29_743}
      t << {Country: "Albania", Population: 3_038_594, Area: 28_748}
      t << {Country: "Mongolia", Population: 3_031_330, Area: 1_564_116}
      t << {Country: "Jamaica", Population: 2_970_340, Area: 10_991}
      t << {Country: "Lithuania", Population: 2_854_235, Area: 65_300}
      t << {Country: "Kuwait", Population: 2_832_776, Area: 17_818}
      t << {Country: "West Bank", Population: 2_697_687, Area: 5_860}
      t << {Country: "Namibia", Population: 2_436_469, Area: 824_292}
      t << {Country: "Qatar", Population: 2_258_283, Area: 11_586}
      t << {Country: "Botswana", Population: 2_209_208, Area: 581_730}
      t << {Country: "Macedonia", Population: 2_100_025, Area: 25_713}
      t << {Country: "Gambia, The", Population: 2_009_648, Area: 11_295}
      t << {Country: "Slovenia", Population: 1_978_029, Area: 20_273}
      t << {Country: "Latvia", Population: 1_965_686, Area: 64_589}
      t << {Country: "Lesotho", Population: 1_953_070, Area: 30_355}
      t << {Country: "Kosovo", Population: 1_883_018, Area: 10_887}
      t << {Country: "Guinea-Bissau", Population: 1_759_159, Area: 36_125}
      t << {Country: "Gaza Strip", Population: 1_753_327, Area: 360}
      t << {Country: "Gabon", Population: 1_738_541, Area: 267_667}
      t << {Country: "Swaziland", Population: 1_451_428, Area: 17_364}
      t << {Country: "Bahrain", Population: 1_378_904, Area: 760}
      t << {Country: "Mauritius", Population: 1_348_242, Area: 2_040}
      t << {Country: "Timor-Leste", Population: 1_261_072, Area: 14_874}
      t << {Country: "Estonia", Population: 1_258_545, Area: 45_228}
      t << {Country: "Trinidad and Tobago", Population: 1_220_479, Area: 5_128}
      t << {Country: "Cyprus", Population: 1_205_575, Area: 9_251}
      t << {Country: "Fiji", Population: 915_303, Area: 18_274}
      t << {Country: "Djibouti", Population: 846_687, Area: 23_200}
      t << {Country: "Comoros", Population: 794_678, Area: 2_235}
      t << {Country: "Equatorial Guinea", Population: 759_451, Area: 28_051}
      t << {Country: "Bhutan", Population: 750_125, Area: 38_394}
      t << {Country: "Guyana", Population: 735_909, Area: 214_969}
      t << {Country: "Montenegro", Population: 644_578, Area: 13_812}
      t << {Country: "Solomon Islands", Population: 635_027, Area: 28_896}
      t << {Country: "Macau", Population: 597_425, Area: 28}
      t << {Country: "Western Sahara", Population: 587_020, Area: 266_000}
      t << {Country: "Suriname", Population: 585_824, Area: 163_820}
      t << {Country: "Luxembourg", Population: 582_291, Area: 2_586}
      t << {Country: "Cabo Verde", Population: 553_432, Area: 4_033}
      t << {Country: "Brunei", Population: 436_620, Area: 5_765}
      t << {Country: "Malta", Population: 415_196, Area: 316}
      t << {Country: "Maldives", Population: 392_960, Area: 298}
      t << {Country: "Belize", Population: 353_858, Area: 22_966}
      t << {Country: "Iceland", Population: 335_878, Area: 103_000}
      t << {Country: "Bahamas, The", Population: 327_316, Area: 13_880}
      t << {Country: "Barbados", Population: 291_495, Area: 430}
      t << {Country: "French Polynesia", Population: 285_321, Area: 4_167}
      t << {Country: "Vanuatu", Population: 277_554, Area: 12_189}
      t << {Country: "New Caledonia", Population: 275_355, Area: 18_575}
      t << {Country: "Samoa", Population: 198_926, Area: 2_831}
      t << {Country: "Sao Tome and Principe", Population: 197_541, Area: 964}
      t << {Country: "Saint Lucia", Population: 164_464, Area: 616}
      t << {Country: "Guam", Population: 162_742, Area: 544}
      t << {Country: "Curacao", Population: 149_035, Area: 444}
      t << {Country: "Aruba", Population: 113_648, Area: 180}
      t << {Country: "Grenada", Population: 111_219, Area: 344}
      t << {Country: "Kiribati", Population: 106_925, Area: 811}
      t << {Country: "Tonga", Population: 106_513, Area: 747}
      t << {Country: "Micronesia, Federated States of", Population: 104_719, Area: 702}
      t << {Country: "Virgin Islands", Population: 102_951, Area: 1_910}
      t << {Country: "Saint Vincent and the Grenadines", Population: 102_350, Area: 389}
      t << {Country: "Jersey", Population: 98_069, Area: 116}
      t << {Country: "Antigua and Barbuda", Population: 93_581, Area: 443}
      t << {Country: "Seychelles", Population: 93_186, Area: 455}
      t << {Country: "Isle of Man", Population: 88_195, Area: 572}
      t << {Country: "Andorra", Population: 85_660, Area: 468}
      t << {Country: "Dominica", Population: 73_757, Area: 751}
      t << {Country: "Marshall Islands", Population: 73_376, Area: 181}
      t << {Country: "Bermuda", Population: 70_537, Area: 54}
      t << {Country: "Guernsey", Population: 66_297, Area: 78}
      t << {Country: "Greenland", Population: 57_728, Area: 2_166_086}
      t << {Country: "Cayman Islands", Population: 57_268, Area: 264}
      t << {Country: "American Samoa", Population: 54_194, Area: 199}
      t << {Country: "Northern Mariana Islands", Population: 53_467, Area: 464}
      t << {Country: "Saint Kitts and Nevis", Population: 52_329, Area: 261}
      t << {Country: "Turks and Caicos Islands", Population: 51_430, Area: 948}
      t << {Country: "Faroe Islands", Population: 50_456, Area: 1_393}
      t << {Country: "Sint Maarten", Population: 41_486, Area: 34}
      t << {Country: "Liechtenstein", Population: 37_937, Area: 160}
      t << {Country: "British Virgin Islands", Population: 34_232, Area: 151}
      t << {Country: "San Marino", Population: 33_285, Area: 61}
      t << {Country: "Saint Martin", Population: 31_949, Area: 54}
      t << {Country: "Monaco", Population: 30_581, Area: 2}
      t << {Country: "Gibraltar", Population: 29_328, Area: 7}
      t << {Country: "Palau", Population: 21_347, Area: 459}
      t << {Country: "Anguilla", Population: 16_752, Area: 91}
      t << {Country: "Wallis and Futuna", Population: 15_664, Area: 142}
      t << {Country: "Tuvalu", Population: 10_959, Area: 26}
      t << {Country: "Nauru", Population: 9_591, Area: 21}
      t << {Country: "Cook Islands", Population: 9_556, Area: 236}
      t << {Country: "Saint Helena, Ascension, and Tristan da Cunha", Population: 7_795, Area: 308}
      t << {Country: "Saint Pierre and Miquelon", Population: 5_595, Area: 242}
      t << {Country: "Montserrat", Population: 5_267, Area: 102}
      t << {Country: "Falkland Islands (Islas Malvinas)", Population: 2_931, Area: 12_173}
      t << {Country: "Norfolk Island", Population: 2_210, Area: 36}
      t << {Country: "Christmas Island", Population: 2_205, Area: 135}
      t << {Country: "Svalbard", Population: 1_872, Area: 62_045}
      t << {Country: "Tokelau", Population: 1_337, Area: 12}
      t << {Country: "Niue", Population: 1_190, Area: 260}
      t << {Country: "Holy See (Vatican City)", Population: 1_000, Area: 0}
      t << {Country: "Cocos (Keeling) Islands", Population: 596, Area: 14}
      t << {Country: "Pitcairn Islands", Population: 54, Area: 47}
      t
    end
  end
end
