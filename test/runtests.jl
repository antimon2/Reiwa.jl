using Reiwa
using Unicode
using Test


@testset "instantiate" begin

rstr = ReiwaString("\u337e\u337d\u337c\u337b\u32ff")
rstr2 = reiwa"㍾㍽㍼㍻㋿"
@test rstr == rstr2 == "\u337e\u337d\u337c\u337b\u32ff" == "㍾㍽㍼㍻㋿"

end

@testset "io" begin

rstr = reiwa"㍾㍽㍼㍻㋿"
@test sprint(print, rstr) == "㍾㍽㍼㍻㋿"
@test sprint(show, rstr) == "reiwa\"㍾㍽㍼㍻㋿\""

rstr3 = reiwa"\u337b31年度\t（\u32ff元年度）\n"
@test sprint(print, rstr3) == "㍻31年度\t（㋿元年度）\n"
@test sprint(show, rstr3) == "reiwa\"㍻31年度\\t（㋿元年度）\\n\""

end

@testset "iteration" begin

rstr = reiwa"㍾㍽㍼㍻㋿"
@test rstr[1] == '㍾' == '\u337e'
@test rstr[4] == '㍽' == '\u337d'
@test rstr[7] == '㍼' == '\u337c'
@test rstr[10] == '㍻' == '\u337b'
@test rstr[13] == '㋿' == '\u32ff'
@test collect(rstr) == Char[0x337e, 0x337d, 0x337c, 0x337b, 0x32ff]

end

@testset "isassigned" begin

@test Unicode.isassigned('\u337e')
@test Unicode.isassigned('\u337d')
@test Unicode.isassigned('\u337c')
@test Unicode.isassigned('\u337b')
@test Unicode.isassigned('\u32ff')
@test Unicode.isassigned(0x337e)
@test Unicode.isassigned(0x337d)
@test Unicode.isassigned(0x337c)
@test Unicode.isassigned(0x337b)
@test Unicode.isassigned(0x32ff)

end

@testset "normalize" begin

rstr = reiwa"\u337e\u337d\u337c\u337b\u32ff"
@test Unicode.normalize(rstr, :NFC) == "㍾㍽㍼㍻㋿"
@test Unicode.normalize(rstr, :NFD) == "㍾㍽㍼㍻㋿"
@test Unicode.normalize(rstr, :NFKC) == "明治大正昭和平成令和"
@test Unicode.normalize(rstr, :NFKD) == "明治大正昭和平成令和"
@test Unicode.normalize(rstr, compat=true) == "明治大正昭和平成令和"
@test Unicode.normalize(rstr) == "㍾㍽㍼㍻㋿"

rstr3 = reiwa"㍻31年度（\u32ff元年度）"
@test Unicode.normalize(rstr3, :NFC) == "㍻31年度（㋿元年度）"
@test Unicode.normalize(rstr3, :NFD) == "㍻31年度（㋿元年度）"
@test Unicode.normalize(rstr3, :NFKC) == "平成31年度(令和元年度)"
@test Unicode.normalize(rstr3, :NFKD) == "平成31年度(令和元年度)"
@test Unicode.normalize(rstr3, compat=true) == "平成31年度(令和元年度)"
@test Unicode.normalize(rstr3) == "㍻31年度（㋿元年度）"

end
