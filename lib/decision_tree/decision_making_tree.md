从以下我的个人博客搬运：
https://www.cnblogs.com/codexspace/p/14309656.html


好久没写代码了，最近手又痒了。对大数据比较感兴趣，就找了几个主题再看，今天看的是决策树，也学习了其他博友的文章，最后自己做了个实现。

先抛一个问题，以网上常见的打高尔夫为例。现已知如下条件，请判断后续出现新的天气情况下，顾客是否会来打球？

数据：golf.dat

复制代码
outlook,temperature,humidity,windy,play
sunny,hot,high,FALSE,no
sunny,hot,high,TRUE,no
overcast,hot,high,FALSE,yes
rainy,mild,high,FALSE,yes
rainy,cool,normal,FALSE,yes
rainy,cool,normal,TRUE,no
overcast,cool,normal,TRUE,yes
sunny,mild,high,FALSE,no
sunny,cool,normal,FALSE,yes
rainy,mild,normal,FALSE,yes
sunny,mild,normal,TRUE,yes
overcast,mild,high,TRUE,yes
overcast,hot,normal,FALSE,yes
rainy,mild,high,TRUE,no
复制代码
第一行是特征。现在我们使用ID3归纳决策树的方法来求解该问题。先介绍几个概念（感谢https://www.cnblogs.com/baiboy/p/pybnc3.html 整理）：

什么是决策树
维基百科：决策树（Decision Tree）是一个预测模型；他代表的是对象属性与对象值之间的一种映射关系。树中每个节点表示某个对象，而每个分叉路径则代表某个可能的属性值，而每个叶节点则对应从根节点到该叶节点所经历的路径所表示的对象的值。数据挖掘中决策树是一种经常要用到的技术，可以用于分析数据，同样也可以用来作预测。从数据产生决策树的机器学习技术叫做决策树学习,通俗说就是决策树。

用决策树对需要测试的实例进行分类：从根节点开始，对实例的某一特征进行测试，根据测试结果，将实例分配到其子结点；这时，每一个子结点对应着该特征的一个取值。如此递归地对实例进行测试并分配，直至达到叶结点。最后将实例分配到叶结点的类中。

什么是信息熵和信息增益
熵（entropy）： 熵指的是体系的混乱的程度，在不同的学科中也有引申出的更为具体的定义，是各领域十分重要的参量。

信息论（information theory）中的熵（香农熵）： 是一种信息的度量方式，表示信息的混乱程度，也就是说：信息越有序，信息熵越低。例如：火柴有序放在火柴盒里，熵值很低，相反，熵值很高。

信息增益（information gain）： 在划分数据集前后信息发生的变化称为信息增益，信息增益越大，确定性越强。

几个公式：（摘自https://blog.csdn.net/qq_38773180/article/details/79188510）

熵：如果当前样本集合D中第K类样本所占的比例为pk，那么D的信息熵定义为:

离散属性a有V个可能取值{a1,a2,...,av},样本集合中，属性a上取值为av的样本集合，记为Dv。则用属性a对样本集D进行划分所获得的“信息增益”为:

我们计算得到的信息增益表示得知属性a的信息而使得样本集合不确定度减少的程度。构造树的基本想法是随着树深度的增加，节点的熵迅速地降低。熵降低的速度越快越好，这样我们有望得到一棵高度最矮的决策树。。

决策树算法流程
收集数据：可以使用任何方法。
准备数据：树构造算法 (这里使用的是ID3算法，只适用于标称型数据，这就是为什么数值型数据必须离散化。 还有其他的树构造算法，比如CART)
分析数据：可以使用任何方法，构造树完成之后，我们应该检查图形是否符合预期。
训练算法：构造树的数据结构。
测试算法：使用训练好的树计算错误率。
使用算法：此步骤可以适用于任何监督学习任务，而使用决策树可以更好地理解数据的内在含义。
伪代码（采用递归的思想）
buildTree():
    检测数据集中的所有数据的分类标签是否相同:
        If so return 类标签
        Else:
            寻找划分数据集的最好特征（划分之后信息熵最小，也就是信息增益最大的特征）
            划分数据集
            创建分支节点
                for 每个划分的子集
                    调用函数 buildTree （创建分支的函数）并增加返回结果到分支节点中
            return 分支节点
好，概念介绍完了，下面开始数据分析。

在没有给定任何天气信息时，根据历史数据，我们只知道新的一天打球的概率是9/14，不打的概率是5/14。此时的熵为：

 特征有4个：outlook，temperature，humidity，windy。我们首先要决定哪个特征作树的根节点。

下面我们计算当已知变量outlook的值时，信息熵为多少。

outlook=sunny时，2/5的概率打球，3/5的概率不打球。entropy=0.971

outlook=overcast时，entropy=0

outlook=rainy时，entropy=0.971

而根据历史统计数据，outlook取值为sunny、overcast、rainy的概率分别是5/14、4/14、5/14，所以当已知变量outlook的值时，信息熵为：5/14 × 0.971 + 4/14 × 0 + 5/14 × 0.971 = 0.693

这样的话系统熵就从0.940下降到了0.693，信息增溢gain(outlook)为0.940-0.693=0.247

同样可以计算出gain(temperature)=0.029，gain(humidity)=0.152，gain(windy)=0.048。

gain(outlook)最大（即outlook在第一步使系统的信息熵下降得最快），所以决策树的根节点就取outlook

接下来要确定N1取temperature、humidity还是windy?在已知outlook=sunny的情况，根据历史数据，我们作出类似table 2的一张表，分别计算gain(temperature)、gain(humidity)和gain(windy)，选最大者为N1。

依此类推，构造决策树。当系统的信息熵降为0时，就没有必要再往下构造决策树了，此时叶子节点都是纯的--这是理想情况。最坏的情况下，决策树的高度为属性（决策变量）的个数，叶子节点不纯（这意味着我们要以一定的概率来作出决策）。

 dart 代码实现：

// 首先做一个对数处理
double log2(num x) => log(x) / ln2;
// 针对概率序列p(p1,p2,...,pn),熵为：（用到了List类的fold方法）
double _entropy(Iterable<double> p) =>
    -p.fold(0, (prev, x) => prev + x * log2(x));

// 求一组数据各种可能发生的概率（即最后一列的概率）。用到了dart Map类的update方法。
Iterable<double> _probability(List data) {
  var map = <Object, int>{};
  for (var row in data) map.update(row.last, (v) => v + 1, ifAbsent: () => 1);
  return map.values.map((e) => e / data.length);
}

// 求一组数据的熵。
double entropy(List data) => _entropy(_probability(data));
复制代码
// 根据第i列特征，对数据进行分类
Map<Object, List> classify(List data, int i) {
  var map = <Object, List>{};
  for (var row in data) {
    map.update(row[i], (v) {
      v.add(row);
      return v;
    }, ifAbsent: () => [row]);
  }
  return map;
}

// 对给定的数据data，求增益最大的特征。
// usedAttrs 为已经使用过的特征，不能重复使用;
// t 为该组数据的总的熵，避免重复计算；
int bestAttr(List data, List<int> usedAttrs, double totalEnt) {
  var gains = [
    for (var i = 0; i < data[0].length - 1; i++)
      // 注意对于已经使用过的特征，一定要给予一个负值，以确保其不会对后续的计算产生干扰
      usedAttrs.contains(i) ? -1 : gain(totalEnt, data, i)
  ];

  var best = 0, maxg = gains[0];
  for (var i = 1; i < gains.length; i++) {
    if (maxg < gains[i]) {
      maxg = gains[i];
      best = i;
    }
  }
  return best;
}

// 计算以第i列为分类的信息增益
double gain(double totalEnt, List data, int i) =>
    totalEnt - entropyByAttr(data, i);

// 计算以第i列为分类的熵
double entropyByAttr(List data, int i) {
  var ep = 0.0, groups = classify(data, i).values;
  for (var group in groups) ep += group.length / data.length * entropy(group);
  return ep;
}

// 递归创建决策树
TreeNode buildTree(List data, List<String> attrs, List<int> usedAttrs) {
  // 计算数据集的总熵
  var t = entropy(data);
  // 若总熵为0，说明已经不需要继续分类
  if (t == 0) return TreeNode(data[0].last, null, null);

  // 寻找当前信息增益最大的特征
  var i = bestAttr(data, usedAttrs, t);
  var node = TreeNode(attrs[i], [], []);
  // 注意这里一定要生成新的List，因为List是传递引用的。否则会引起多个child之间的混乱。
  var newUsed = [for (var j in usedAttrs) j, i];

  // 对新的特征进行数据分类，递归计算每个分类
  var groups = classify(data, i);
  for (var entry in groups.entries) {
    node.edges.add(entry.key);
    node.children.add(buildTree(entry.value, attrs, newUsed));
  }
  return node;
}

class TreeNode {
  String attribute; // 特征名称
  List<Object> edges; // 边，也即特征的具体属性
  List<TreeNode> children;

  TreeNode(this.attribute, this.edges, this.children);
}

// 递归打印树
void printTree(TreeNode root, int indent) {
  print('${' ' * indent}特征：${root.attribute}');
  if (root.edges == null) return;

  for (var i = 0; i < root.edges.length; i++) {
    print('${' ' * (indent + 2)}属性：${root.edges[i]}');
    printTree(root.children[i], indent + 4);
  }
}

// 加载数据，采用stream流式加载
Future<Map<String, List>> loadData(String path) async {
  var lines =
      File(path).openRead().transform(utf8.decoder).transform(LineSplitter());

  List<String> attributes;
  var data = <List>[], ln = 0;

  await for (var line in lines) {
    if (ln++ == 0) {
      attributes = line.trim().split(',');
    } else {
      data.add(line.trim().split(','));
    }
  }

  return {'attributes': attributes, 'data': data};
}

// 执行测试
Future<void> dt_run() async {
  // var info = await loadData('./lib/decision_tree/melon.dat');
  var info = await loadData('./lib/decision_tree/golf.dat');
  var attrs = info['attributes'], data = info['data'];
  var root = buildTree(data, attrs, []);
  printTree(root, 0);
}
复制代码
 打印结果如下：

复制代码
特征：outlook
  属性：sunny
    特征：humidity
      属性：high
        特征：no
      属性：normal
        特征：yes
  属性：overcast
    特征：yes
  属性：rainy
    特征：windy
      属性：FALSE
        特征：yes
      属性：TRUE
        特征：no
Exited

------------------------------

数据集 melon.dat 

色泽,根蒂,敲声,纹理,脐部,触感,好瓜
青绿,蜷缩,浊响,清晰,凹陷,硬滑,好瓜
乌黑,蜷缩,沉闷,清晰,凹陷,硬滑,好瓜
乌黑,蜷缩,浊响,清晰,凹陷,硬滑,好瓜
青绿,蜷缩,沉闷,清晰,凹陷,硬滑,好瓜
浅白,蜷缩,浊响,清晰,凹陷,硬滑,好瓜
青绿,稍蜷,浊响,清晰,稍凹,软粘,好瓜
乌黑,稍蜷,浊响,稍糊,稍凹,软粘,好瓜
乌黑,稍蜷,浊响,清晰,稍凹,硬滑,好瓜
乌黑,稍蜷,沉闷,稍糊,稍凹,硬滑,坏瓜
青绿,硬挺,清脆,清晰,平坦,软粘,坏瓜
浅白,硬挺,清脆,模糊,平坦,硬滑,坏瓜
浅白,蜷缩,浊响,模糊,平坦,软粘,坏瓜
青绿,稍蜷,浊响,稍糊,凹陷,硬滑,坏瓜
浅白,稍蜷,沉闷,稍糊,凹陷,硬滑,坏瓜
乌黑,稍蜷,浊响,清晰,稍凹,软粘,坏瓜
浅白,蜷缩,浊响,模糊,平坦,硬滑,坏瓜
青绿,蜷缩,沉闷,稍糊,稍凹,硬滑,坏瓜

测试结果：

复制代码
特征：纹理
  属性：清晰
    特征：根蒂
      属性：蜷缩
        特征：好瓜
      属性：稍蜷
        特征：色泽
          属性：青绿
            特征：好瓜
          属性：乌黑
            特征：触感
              属性：硬滑
                特征：好瓜
              属性：软粘
                特征：坏瓜
      属性：硬挺
        特征：坏瓜
  属性：稍糊
    特征：触感
      属性：软粘
        特征：好瓜
      属性：硬滑
        特征：坏瓜
  属性：模糊
    特征：坏瓜
Exited

以上就是一个简单的示例和完整的dart代码实现，借鉴了多位博友的总结，再次感谢。决策树还有很多更进一步的话题，后面慢慢学。 

感谢如下博友的博客：
https://blog.csdn.net/qq_38773180/article/details/79188510
https://www.cnblogs.com/zhangchaoyang/articles/2196631.html
https://www.cnblogs.com/baiboy/p/pybnc3.html