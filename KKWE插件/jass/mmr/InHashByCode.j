#include"mmr\\mmrapi.j"

#ifndef InHashByCodeIncluded
#define InHashByCodeIncluded 

library InHashByCode 

	function InHashByCode_Shop takes hashtable hs returns nothing
       local hashtable  willinhash = hs
       // ==== 0 ====
call SaveStr( willinhash, 0, 0, "金币礼包" )
call SaveStr( willinhash, 0, 1, "木材礼包" )
call SaveStr( willinhash, 0, 2, "天生神力" )
call SaveStr( willinhash, 0, 3, "背包第二页" )
call SaveStr( willinhash, 0, 4, "杀敌特权" )
call SaveStr( willinhash, 0, 5, "额外属性" )
call SaveStr( willinhash, 0, 6, "无CD闪烁" )
call SaveStr( willinhash, 0, 7, "背包第三页" )
call SaveStr( willinhash, 0, 8, "传承之力" )
call SaveStr( willinhash, 0, 9, "背包第四页" )
call SaveStr( willinhash, 0, 10, "法则之书上卷" )
call SaveStr( willinhash, 0, 11, "法则之书中卷" )
call SaveStr( willinhash, 0, 12, "法则之书下卷" )
call SaveStr( willinhash, 0, 13, "法则之书总纲" )
call SaveStr( willinhash, 0, 14, "惊寂" )
call SaveStr( willinhash, 0, 15, "永夜" )
call SaveStr( willinhash, 0, 16, "万象" )
call SaveStr( willinhash, 0, 17, "灭绝" )
call SaveStr( willinhash, 0, 18, "咸鱼突刺(UR)" )
call SaveStr( willinhash, 0, 19, "金馆长的微笑(UR)" )
call SaveStr( willinhash, 0, 20, "蓝蓝路！(UR)" )
call SaveStr( willinhash, 0, 21, "灵魂权杖(SSR)" )
call SaveStr( willinhash, 0, 22, "金之本源(SSR)" )
call SaveStr( willinhash, 0, 23, "必斩必杀(SSR)" )
call SaveStr( willinhash, 0, 24, "雷霆万钧(SSR)" )
call SaveStr( willinhash, 0, 25, "极致之力(SSR)" )
call SaveStr( willinhash, 0, 26, "森罗镇狱(SSR)" )
call SaveStr( willinhash, 0, 27, "成长之心(SR)" )
call SaveStr( willinhash, 0, 28, "锋锐之心(SR)" )
call SaveStr( willinhash, 0, 29, "防御之心(SR)" )
call SaveStr( willinhash, 0, 30, "力量源泉碎片(R)" )
call SaveStr( willinhash, 0, 31, "敏捷源泉碎片(R)" )
call SaveStr( willinhash, 0, 32, "智力源泉碎片(R)" )
call SaveStr( willinhash, 0, 33, "生命源泉碎片(R)" )
call SaveStr( willinhash, 0, 34, "魔力源泉碎片(R)" )
call SaveStr( willinhash, 0, 35, "力量传承碎片(N)" )
call SaveStr( willinhash, 0, 36, "敏捷传承碎片(N)" )
call SaveStr( willinhash, 0, 37, "智力传承碎片(N)" )
call SaveStr( willinhash, 0, 38, "生命传承碎片(N)" )
call SaveStr( willinhash, 0, 39, "魔力传承碎片(N)" )
call SaveStr( willinhash, 0, 40, "攻速传承碎片(N)" )
call SaveStr( willinhash, 0, 41, "防御传承碎片(N)" )
call SaveStr( willinhash, 0, 42, "生命药水(N)" )
call SaveStr( willinhash, 0, 43, "魔法药水(N)" )
call SaveStr( willinhash, 0, 44, "一些金币(N)" )
// ==== 1 ====
call SaveStr( willinhash, 1, 0, "开局金币+50" )
call SaveStr( willinhash, 1, 1, "开局金币+200" )
call SaveStr( willinhash, 1, 2, "生命最大值+100" )
call SaveStr( willinhash, 1, 3, "开启存档装备背包第二页" )
call SaveStr( willinhash, 1, 4, "杀敌+1攻击力" )
call SaveStr( willinhash, 1, 5, "基础力量+20
基础敏捷+20
基础智力+20" )
call SaveStr( willinhash, 1, 6, "动态力量百分比+1%
动态敏捷百分比+1%
动态智力百分比+1%
闪烁不再具有CD" )
call SaveStr( willinhash, 1, 7, "开启存档装备背包第三页" )
call SaveStr( willinhash, 1, 8, "杀十个敌人力量+1
杀十个敌人敏捷+1
杀十个敌人智力+1
杀十个敌人最大生命值+10
杀十个敌人最大魔法值+10" )
call SaveStr( willinhash, 1, 9, "开启存档装备背包第四页" )
call SaveStr( willinhash, 1, 10, "动态力量百分比+3%
动态敏捷百分比+3%
动态智力百分比+3%
动态最大生命值百分比+3%
动态最大魔法值百分比+3%
基础生命+300" )
call SaveStr( willinhash, 1, 11, "动态力量百分比+3%
动态敏捷百分比+3%
动态智力百分比+3%
动态最大生命值百分比+3%
动态最大魔法值百分比+3%
基础魔法+300" )
call SaveStr( willinhash, 1, 12, "动态力量百分比+3%
动态敏捷百分比+3%
动态智力百分比+3%
动态最大生命值百分比+3%
动态最大魔法值百分比+3%
基础攻击力+30" )
call SaveStr( willinhash, 1, 13, "动态力量百分比+5%
动态敏捷百分比+5%
动态智力百分比+5%" )
call SaveStr( willinhash, 1, 14, "杀十个敌人智力+5
杀十个敌人最大生命值+30
杀十个敌人最大魔法值+30" )
call SaveStr( willinhash, 1, 15, "杀十个敌人敏捷+5
杀十个敌人最大生命值+30
杀十个敌人最大魔法值+30" )
call SaveStr( willinhash, 1, 16, "杀十个敌人力量+5
杀十个敌人最大生命值+30
杀十个敌人最大魔法值+30" )
call SaveStr( willinhash, 1, 17, "杀十个敌人攻击力+5
杀十个敌人最大生命值+30
杀十个敌人最大魔法值+30" )
call SaveStr( willinhash, 1, 18, "造成伤害时有概率向正面突进一段距离" )
call SaveStr( willinhash, 1, 19, "每次造成伤害时有概率获得一定金币与英雄等级相关" )
call SaveStr( willinhash, 1, 20, "额外获得一个无敌的蓝蓝路，每次攻击造成全属性x1的伤害" )
call SaveStr( willinhash, 1, 21, "物理暴击率+5%
魔法暴击率+5%
物理伤害+5%
魔法伤害+5%
最终伤害+5%" )
call SaveStr( willinhash, 1, 22, "物理暴击率+2%
魔法暴击率+2%
物理伤害+3%
魔法伤害+3%
最终伤害+1%
杀敌金币+1" )
call SaveStr( willinhash, 1, 23, "物理暴击率+2%
魔法暴击率+2%
物理伤害+3%
魔法伤害+3%
最终伤害+1%
杀敌木材+1" )
call SaveStr( willinhash, 1, 24, "杀十个敌人力量+5
动态力量百分比+5%
魔法伤害+3%
物理伤害+3%" )
call SaveStr( willinhash, 1, 25, "杀十个敌人敏捷+5
动态敏捷百分比+5%
魔法伤害+3%
物理伤害+3%" )
call SaveStr( willinhash, 1, 26, "杀十个敌人智力+5
动态智力百分比+5%
魔法伤害+3%
物理伤害+3%" )
call SaveStr( willinhash, 1, 27, "杀十个敌人力量+1
杀十个敌人敏捷+1
杀十个敌人智力+1" )
call SaveStr( willinhash, 1, 28, "杀十个敌人攻击+3" )
call SaveStr( willinhash, 1, 29, "防御力+5" )
call SaveStr( willinhash, 1, 30, "基础力量+5" )
call SaveStr( willinhash, 1, 31, "基础敏捷+5" )
call SaveStr( willinhash, 1, 32, "基础智力+5" )
call SaveStr( willinhash, 1, 33, "最大生命值+200" )
call SaveStr( willinhash, 1, 34, "最大魔法值+200" )
call SaveStr( willinhash, 1, 35, "基础力量+1" )
call SaveStr( willinhash, 1, 36, "基础敏捷+1" )
call SaveStr( willinhash, 1, 37, "基础智力+1" )
call SaveStr( willinhash, 1, 38, "最大生命值+50" )
call SaveStr( willinhash, 1, 39, "最大魔法值+50" )
call SaveStr( willinhash, 1, 40, "攻速+1%" )
call SaveStr( willinhash, 1, 41, "防御力+2" )
call SaveStr( willinhash, 1, 42, "每秒生命回复+5" )
call SaveStr( willinhash, 1, 43, "每秒魔法回复+5" )
call SaveStr( willinhash, 1, 44, "开局金币+100" )
// ==== 2 ====
call SaveStr( willinhash, 2, 0, "JB" )
call SaveStr( willinhash, 2, 1, "MC" )
call SaveStr( willinhash, 2, 2, "RMBDJ1" )
call SaveStr( willinhash, 2, 3, "RMBDJ2" )
call SaveStr( willinhash, 2, 4, "RMBDJ3" )
call SaveStr( willinhash, 2, 5, "RMBDJ4" )
call SaveStr( willinhash, 2, 6, "RMBDJ5" )
call SaveStr( willinhash, 2, 7, "RMBDJ6" )
call SaveStr( willinhash, 2, 8, "RMBDJ7" )
call SaveStr( willinhash, 2, 9, "RMBDJ8" )
call SaveStr( willinhash, 2, 10, "RMBDJ9" )
call SaveStr( willinhash, 2, 11, "RMBDJ10" )
call SaveStr( willinhash, 2, 12, "RMBDJ11" )
call SaveStr( willinhash, 2, 13, "RMBDJ12" )
call SaveStr( willinhash, 2, 14, "RMBDJ13" )
call SaveStr( willinhash, 2, 15, "RMBDJ14" )
call SaveStr( willinhash, 2, 16, "RMBDJ15" )
call SaveStr( willinhash, 2, 17, "RMBDJ16" )
call SaveStr( willinhash, 2, 18, "URCJDJ1" )
call SaveStr( willinhash, 2, 19, "URCJDJ2" )
call SaveStr( willinhash, 2, 20, "URCJDJ3" )
call SaveStr( willinhash, 2, 21, "SSRCJDJ1" )
call SaveStr( willinhash, 2, 22, "SSRCJDJ2" )
call SaveStr( willinhash, 2, 23, "SSRCJDJ3" )
call SaveStr( willinhash, 2, 24, "SSRCJDJ4" )
call SaveStr( willinhash, 2, 25, "SSRCJDJ5" )
call SaveStr( willinhash, 2, 26, "SSRCJDJ6" )
call SaveStr( willinhash, 2, 27, "SRCJDJ1" )
call SaveStr( willinhash, 2, 28, "SRCJDJ2" )
call SaveStr( willinhash, 2, 29, "SRCJDJ3" )
call SaveStr( willinhash, 2, 30, "RCJDJ1" )
call SaveStr( willinhash, 2, 31, "RCJDJ2" )
call SaveStr( willinhash, 2, 32, "RCJDJ3" )
call SaveStr( willinhash, 2, 33, "RCJDJ4" )
call SaveStr( willinhash, 2, 34, "RCJDJ5" )
call SaveStr( willinhash, 2, 35, "NCJDJ1" )
call SaveStr( willinhash, 2, 36, "NCJDJ2" )
call SaveStr( willinhash, 2, 37, "NCJDJ3" )
call SaveStr( willinhash, 2, 38, "NCJDJ4" )
call SaveStr( willinhash, 2, 39, "NCJDJ5" )
call SaveStr( willinhash, 2, 40, "NCJDJ6" )
call SaveStr( willinhash, 2, 41, "NCJDJ7" )
call SaveStr( willinhash, 2, 42, "NCJDJ8" )
call SaveStr( willinhash, 2, 43, "NCJDJ9" )
call SaveStr( willinhash, 2, 44, "NCJDJ10" )
// ==== 3 ====
call SaveStr( willinhash, 3, 0, "KKStor\\ShopBuy\\JB.tga" )
call SaveStr( willinhash, 3, 1, "KKStor\\ShopBuy\\MC.tga" )
call SaveStr( willinhash, 3, 2, "KKStor\\ShopBuy\\RMBDJ1.tga" )
call SaveStr( willinhash, 3, 3, "KKStor\\ShopBuy\\RMBDJ2.tga" )
call SaveStr( willinhash, 3, 4, "KKStor\\ShopBuy\\RMBDJ3.tga" )
call SaveStr( willinhash, 3, 5, "KKStor\\ShopBuy\\RMBDJ4.tga" )
call SaveStr( willinhash, 3, 6, "KKStor\\ShopBuy\\RMBDJ5.tga" )
call SaveStr( willinhash, 3, 7, "KKStor\\ShopBuy\\RMBDJ6.tga" )
call SaveStr( willinhash, 3, 8, "KKStor\\ShopBuy\\RMBDJ7.tga" )
call SaveStr( willinhash, 3, 9, "KKStor\\ShopBuy\\RMBDJ8.tga" )
call SaveStr( willinhash, 3, 10, "KKStor\\ShopBuy\\RMBDJ9.tga" )
call SaveStr( willinhash, 3, 11, "KKStor\\ShopBuy\\RMBDJ10.tga" )
call SaveStr( willinhash, 3, 12, "KKStor\\ShopBuy\\RMBDJ11.tga" )
call SaveStr( willinhash, 3, 13, "KKStor\\ShopBuy\\RMBDJ12.tga" )
call SaveStr( willinhash, 3, 14, "KKStor\\ShopBuy\\RMBDJ13.tga" )
call SaveStr( willinhash, 3, 15, "KKStor\\ShopBuy\\RMBDJ14.tga" )
call SaveStr( willinhash, 3, 16, "KKStor\\ShopBuy\\RMBDJ15.tga" )
call SaveStr( willinhash, 3, 17, "KKStor\\ShopBuy\\RMBDJ16.tga" )
call SaveStr( willinhash, 3, 18, "KKStor\\BOX_UR\\URCJDJ1.tga" )
call SaveStr( willinhash, 3, 19, "KKStor\\BOX_UR\\URCJDJ2.tga" )
call SaveStr( willinhash, 3, 20, "KKStor\\BOX_UR\\URCJDJ3.tga" )
call SaveStr( willinhash, 3, 21, "KKStor\\BOX_SSR\\SSRCJDJ1.tga" )
call SaveStr( willinhash, 3, 22, "KKStor\\BOX_SSR\\SSRCJDJ2.tga" )
call SaveStr( willinhash, 3, 23, "KKStor\\BOX_SSR\\SSRCJDJ3.tga" )
call SaveStr( willinhash, 3, 24, "KKStor\\BOX_SSR\\SSRCJDJ4.tga" )
call SaveStr( willinhash, 3, 25, "KKStor\\BOX_SSR\\SSRCJDJ5.tga" )
call SaveStr( willinhash, 3, 26, "KKStor\\BOX_SSR\\SSRCJDJ6.tga" )
call SaveStr( willinhash, 3, 27, "KKStor\\BOX_SR\\SRCJDJ1.tga" )
call SaveStr( willinhash, 3, 28, "KKStor\\BOX_SR\\SRCJDJ2.tga" )
call SaveStr( willinhash, 3, 29, "KKStor\\BOX_SR\\SRCJDJ3.tga" )
call SaveStr( willinhash, 3, 30, "KKStor\\BOX_R\\RCJDJ1.tga" )
call SaveStr( willinhash, 3, 31, "KKStor\\BOX_R\\RCJDJ2.tga" )
call SaveStr( willinhash, 3, 32, "KKStor\\BOX_R\\RCJDJ3.tga" )
call SaveStr( willinhash, 3, 33, "KKStor\\BOX_R\\RCJDJ4.tga" )
call SaveStr( willinhash, 3, 34, "KKStor\\BOX_R\\RCJDJ5.tga" )
call SaveStr( willinhash, 3, 35, "KKStor\\BOX_N\\NCJDJ1.tga" )
call SaveStr( willinhash, 3, 36, "KKStor\\BOX_N\\NCJDJ2.tga" )
call SaveStr( willinhash, 3, 37, "KKStor\\BOX_N\\NCJDJ3.tga" )
call SaveStr( willinhash, 3, 38, "KKStor\\BOX_N\\NCJDJ4.tga" )
call SaveStr( willinhash, 3, 39, "KKStor\\BOX_N\\NCJDJ5.tga" )
call SaveStr( willinhash, 3, 40, "KKStor\\BOX_N\\NCJDJ6.tga" )
call SaveStr( willinhash, 3, 41, "KKStor\\BOX_N\\NCJDJ7.tga" )
call SaveStr( willinhash, 3, 42, "KKStor\\BOX_N\\NCJDJ8.tga" )
call SaveStr( willinhash, 3, 43, "KKStor\\BOX_N\\NCJDJ9.tga" )
call SaveStr( willinhash, 3, 44, "KKStor\\BOX_N\\NCJDJ10.tga" )

    endfunction

endlibrary


#endif
