import Foundation

// MARK: - 生命档案馆（生命科学史故事，篇末钩回考点）

enum LoreData {
    static let stories: [LoreStory] = [
        LoreStory(id: "dna_race", icon: "photo.on.rectangle.angled",
                  title: "51 号照片", subtitle: "DNA 双螺旋背后的较量",
                  body: "1952 年，富兰克林拍下了那张著名的 DNA X 射线衍射「51 号照片」，清晰显示出螺旋结构。沃森看到照片后大受启发，与克里克迅速搭出了反向平行的双螺旋模型，A 配 T、G 配 C。1962 年三位男性获诺奖，而富兰克林已因病早逝，她的贡献长期被低估。",
                  examHook: "钩回考点：DNA 规则双螺旋、反向平行、碱基互补配对（A=T、G≡C）。"),
        LoreStory(id: "penicillin", icon: "allergens",
                  title: "发霉的培养皿", subtitle: "青霉素的偶然发现",
                  body: "1928 年，弗莱明度假回来，发现一个忘记盖好的培养皿长了青霉菌，菌落周围的葡萄球菌竟被「清出」一圈空地。他意识到霉菌分泌了某种杀菌物质——青霉素。这个意外，开启了抗生素时代，拯救了无数生命。",
                  examHook: "钩回考点：微生物（真菌）、抑菌、无菌操作的重要性。"),
        LoreStory(id: "vaccine", icon: "syringe",
                  title: "挤奶女工的手", subtitle: "牛痘战胜天花",
                  body: "18 世纪，天花夺走无数生命。医生詹纳注意到：挤奶女工得过轻微的牛痘后，似乎再也不得天花。他大胆地给一个男孩接种牛痘，男孩果然对天花产生了抵抗力——人类第一支疫苗诞生，天花最终被消灭。",
                  examHook: "钩回考点：特异性免疫、抗原与记忆细胞、疫苗与二次免疫。"),
        LoreStory(id: "dolly", icon: "hare",
                  title: "多莉羊", subtitle: "一只羊改写生命规则",
                  body: "1996 年，科学家把一只成年母羊乳腺细胞的细胞核，移入去核的卵细胞，培育出了与供核羊几乎完全相同的克隆羊多莉。它证明：已经高度分化的动物体细胞的细胞核，依然保留着发育成完整个体的全部遗传信息。",
                  examHook: "钩回考点：细胞核的全能性、核移植、动物细胞工程。"),
        LoreStory(id: "qinghao", icon: "leaf.arrow.triangle.circlepath",
                  title: "青蒿一握", subtitle: "古籍里的诺奖灵感",
                  body: "屠呦呦团队筛选了数百种中药，效果都不稳定。直到她重读东晋葛洪《肘后备急方》：「青蒿一握，以水二升渍，绞取汁」——为什么是绞汁而不是煎煮？她悟到高温会破坏有效成分，改用低温乙醚提取，青蒿素的抗疟活性终于稳定显现。",
                  examHook: "钩回考点：科学探究中的变量控制、温度对物质活性的影响、提取方法的选择。"),
    ]
}
