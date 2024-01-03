import 'dart:convert';
import 'dart:io';
import 'dart:math';

// 执行测试
Future<void> run() async {
  // var info = await loadData('./lib/decision_tree/data/melon.dat');
  var info = await loadData('./lib/decision_tree/data/golf.dat');
  var attrs = info['attributes'], data = info['data'];
  var root = buildTree(data!, attrs as List<String>, []);
  printTree(root, 0);
}

// 递归创建决策树
TreeNode buildTree(List data, List<String> attrs, List<int> usedAttrs) {
  // 计算数据集的总熵
  var t = entropy(data); // 若总熵为0，说明已经不需要继续分类
  if (t == 0) return TreeNode(data[0].last, null, null);
  // 寻找当前信息增益最大的特征
  var i = bestAttr(data, usedAttrs, t);
  var node = TreeNode(
      attrs[i], [], []); // 注意这里一定要生成新的List，因为List是传递引用的。否则会引起多个child之间的混乱。
  var newUsed = [for (var j in usedAttrs) j, i];
  // 对新的特征进行数据分类，递归计算每个分类
  var groups = classify(data, i);
  for (var entry in groups.entries) {
    node.edges!.add(entry.key);
    node.children!.add(buildTree(entry.value, attrs, newUsed));
  }
  return node;
}

// 递归打印树
void printTree(TreeNode root, int indent) {
  print('${' ' * indent}特征：${root.attribute}');
  if (root.edges == null) return;

  for (var i = 0; i < root.edges!.length; i++) {
    print('${' ' * (indent + 2)}属性：${root.edges![i]}');
    printTree(root.children![i], indent + 4);
  }
}

// 加载数据，采用stream流式加载
Future<Map<String, List>> loadData(String path) async {
  var lines = File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  List<String> attributes = [];
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

class TreeNode {
  String attribute; // 特征名称
  List<Object>? edges; // 边，也即特征的具体属性
  List<TreeNode>? children;

  TreeNode(this.attribute, this.edges, this.children);
}

// 对给定的数据data，求增益最大的特征。
// usedAttrs 为已经使用过的特征，不能重复使用;
// t 为该组数据的总的熵，避免重复计算；
int bestAttr(List data, List<int> usedAttrs, double totalEnt) {
  var gains = [
    for (var i = 0;
        i < data[0].length - 1;
        i++) // 注意对于已经使用过的特征，一定要给予一个负值，以确保其不会对后续的计算产生干扰
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
  for (var group in groups) {
    ep += group.length / data.length * entropy(group);
  }
  return ep;
}

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

// 求一组数据的熵。
double entropy(List data) => _entropy(_probability(data));

double log2(num x) => log(x) / ln2;

// 针对概率序列p(p1,p2,...,pn),熵为：
double _entropy(Iterable<double> p) =>
    -p.fold(0.0, (prev, x) => prev + x * log2(x));

// 求一组数据各种可能发生的概率（即最后一列的概率）。用到了dart Map类的update方法。
Iterable<double> _probability(List data) {
  var map = <Object, int>{};
  for (var row in data) {
    map.update(row.last, (v) => v + 1, ifAbsent: () => 1);
  }
  return map.values.map((e) => e / data.length);
}
