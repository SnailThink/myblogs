# leecode 

## Java   [Leecode-100](https://leetcode-cn.com/problem-list/2cktkvj/)

[Leecode刷题技巧](https://github.com/CyC2018/CS-Notes/tree/master/notes)

### 628 [三个数的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-three-numbers/)

 给你一个整型数组 `nums` ，在数组中找出由三个数组成的最大乘积，并输出这个乘积。 

**示例1:**

```java
输入：nums = [1,2,3]
输出：6
```

 **示例 2：** 

```java
输入：nums = [1,2,3,4]
输出：24
```

 **示例 3：** 

```java
输入：nums = [-1,-2,-3]
输出：-6
```

**解题思路**

根据示例可以看出会存在 三种情况

- 数据元素都为正数[排序后将最大的三个数相乘] （ nums[len-3] * nums[len-2] * nums[len-1] ）
- 数组元素都为负数[排序后将最大的三个数相乘]）（ nums[len-3] * nums[len-2] * nums[len-1] ）
- 数最元素有证数有负数[2个最小负数和最大正数相乘] nums[0] * nums[1] * nums[len-1] 

```java
	public int maximumProduct(int[] nums) {
		Arrays.sort(nums);
		int len = nums.length;
		return Math.max(nums[0]*nums[1]*nums[len-1],nums[len-3]*nums[len-2]*nums[len-1]);
	}
```

### 16.26 [计算器](https://leetcode-cn.com/problems/calculator-lcci/)

给定一个包含正整数、加(+)、减(-)、乘(*)、除(/)的算数表达式(括号除外)，计算其结果。

表达式仅包含非负整数，+， - ，*，/ 四种运算符和空格  。 整数除法仅保留整数部分。

**示例 1:**

```
输入: "3+2*2"
输出: 7
```

**示例 2:**

```
输入: " 3/2 "
输出: 1
```

**示例 3:**

```
输入: " 3+5 / 2 "
输出: 5
```

**解题思路**

- 如果碰到数字， 则把数字入栈
- 如果碰到空格， 则继续下一步
- 如果碰到 '+' '-' '*' '/', 则查找下一个数字num
  - A.如果是'+', 下一个数字num直接入栈
  - B.如果是'-'，-num入栈
  - C.如果是'*', num = stack.pop() * num, 入栈
  - D.如果是'/', num = stack.pop() / num, 入栈
- 最后，把栈里的数相加就是结果



```java
/**
	 * 计算器
	 * @param s
	 * @return
	 */
	@Test
	public int calculate(String s) {
		char[] cs = s.trim().toCharArray();
		Stack<Integer> st = new Stack();
		int ans = 0, i = 0;
		while(i < cs.length){
			if(cs[i] == ' ') {i++;continue;}
			char tmp = cs[i];
			if(tmp == '*' || tmp == '/' || tmp == '+' || tmp == '-'){
				i++;
				while(i < cs.length && cs[i] == ' ') i++;
			}
			int num = 0;
			while(i < cs.length && Character.isDigit(cs[i])){
				num = num * 10 + cs[i] - '0';
				i++;
			}
			switch(tmp){
				case '-':
					num = -num;
					break;
				case '*':
					num = st.pop() * num;
					break;
				case '/':
					num = st.pop() / num;
					break;
				default:
					break;
			}
			st.push(num);
		}
		while(!st.isEmpty()) ans += st.pop();
		return ans;
	}
```

### [剑指 Offer 58 - II ](https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/)

字符串的左旋转操作是把字符串前面的若干个字符转移到字符串的尾部。请定义一个函数实现字符串左旋转操作的功能。比如，输入字符串"abcdefg"和数字2，该函数将返回左旋转两位得到的结果"cdefgab"。

**示例 1:**

```
输入: s = "abcdefg", k = 2
输出: "cdefgab"
```



**示例 2:**

```
输入: s = "lrloseumgh", k = 6
输出: "umghlrlose"
```

**解题思路**

- 取n后的字符串 `s.substring(n)`
- 拼接0-n的字符串`s.substring(0,n)`

```java
	public String reverseLeftWords(String s, int n) {
		return s.substring(n).concat(s.substring(0,n));
	}
```

**扩展 字符串反转**

```java
	public static String reverse1(String str) {
		return new StringBuilder(str).reverse().toString();
	}
```



### [767. 重构字符串](https://leetcode-cn.com/problems/reorganize-string/)

给定一个字符串`S`，检查是否能重新排布其中的字母，使得两相邻的字符不同。

若可行，输出任意可行的结果。若不可行，返回空字符串。

**示例 1:**

```java
输入: S = "aab"
输出: "aba"
```

**示例 2:**

```
输入: S = "aaab"
输出: ""
```

**解题思路 -TODO**  

- 
- 

### [136. 只出现一次的数字](https://leetcode-cn.com/problems/single-number/)

 给定一个**非空**整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。 

**示例 1:**

```
输入: [2,2,1]
输出: 1
```

**示例 2:**

```
输入: [4,1,2,1,2]
输出: 4
```

**解题思路**

- 先排序再遍历

```java
    public int singleNumber(int[] nums) {
        Arrays.sort(nums);
        int counter = 0;
        for (int i = 0; i < nums.length - 1; i++) {
            counter++;
            if(counter % 2 == 1 && nums[i] != nums[i + 1]){
                return nums[i];
            }
        }
        return nums[nums.length - 1];
    }
```

**解法二**

- 使用位运算

```java
class Solution {
    public int singleNumber(int[] nums) {
        int single = 0;
        for (int num : nums) {
            single ^= num;
        }
        return single;
    }
}
```

#### 扩展

**查找字符串中某一个字符出现的次数**

```java
/**
	 * 查询字符串中某一个字符出现的次数
	 *
	 * @param str 字符串
	 * @param charStr 字符
	 * @return
	 */
	public static int testFindChar(String str,String charStr) {
		// 存放每个字符的数组
		String[] strs = new String[str.length()];
		// 计数该字符出现了多少次
		int count = 0;
		// 先把字符串转换成数组
		for (int i = 0; i < strs.length; i++) {
			strs[i] = str.substring(i, i + 1);
		}
		// 挨个字符进行查找，查找到之后count++
		for (int i = 0; i < strs.length; i++) {
			if (strs[i].equals(charStr)) {
				count++;
			}
		}
		return count;
	}
```

### [441. 排列硬币](https://leetcode-cn.com/problems/arranging-coins/)

你总共有 n 枚硬币，你需要将它们摆成一个阶梯形状，第 k 行就必须正好有 k 枚硬币。

给定一个数字 n，找出可形成完整阶梯行的总行数。

n 是一个非负整数，并且在32位有符号整型的范围内。

 **示例 1:** 

```
n = 5

硬币可排列成以下几行:
¤
¤ ¤
¤ ¤

因为第三行不完整，所以返回2.
```

 **示例 2:** 

```
n = 8

硬币可排列成以下几行:
¤
¤ ¤
¤ ¤ ¤
¤ ¤

因为第四行不完整，所以返回3.
```

 **解题思路**

- 从第1行阶梯开始累加硬币，即1 + 2 + 3 + ... + k <= n。
- k从1开始枚举，由等差数列求和公式可得sum = (1 + k) * k / 2，
- 最后while循环结束是因为sum > n，所以要返回k - 1。

```java
class Solution {
    public int arrangeCoins(int n) {
        long k = 1, sum = 1;
        while (sum <= n) {
            k++;
            sum = (1 + k) * k / 2;
        }
        return (int) k - 1;
    }
}
```

**方法二【二分法】**

- 答案的范围是[0,n]的有序区间，所以可以使用二分查找。
- 我们要在[0,n]中找到一个数k(代码中的mid)，使得(1 + k) * k / 2刚好小于等于n，如果大于n，就排除一半区间。

```java
class Solution {
    public int arrangeCoins(int n) {
        long left = 0, right = n;
        while (left < right) {
            long mid = left + (right - left + 1) / 2;
            long sum = (1 + mid) * mid / 2;
            // sum大于n一定不是解
            if (sum > n) {
                // 下一轮搜索区间是 [left, mid - 1]
                right = mid - 1;
            } else {
                // 下一轮搜索区间是 [mid, right]
                left = mid;
            }
        }
        return (int) left;
    }
}
```

### [575. 分糖果](https://leetcode-cn.com/problems/distribute-candies/)

给定一个偶数长度的数组，其中不同的数字代表着不同种类的糖果，每一个数字代表一个糖果。你需要把这些糖果平均分给一个弟弟和一个妹妹。返回妹妹可以获得的最大糖果的种类数

 **示例 1:** 

```
输入: candies = [1,1,2,2,3,3]
输出: 3
解析: 一共有三种种类的糖果，每一种都有两个。
     最优分配方案：妹妹获得[1,2,3],弟弟也获得[1,2,3]。这样使妹妹获得糖果的种类数最多。
```

 **示例 2 :** 

```
输入: candies = [1,1,2,3]
输出: 2
解析: 妹妹获得糖果[2,3],弟弟获得糖果[1,1]，妹妹有两种不同的糖果，弟弟只有一种。这样使得妹妹可以获得的糖果种类数最多。
```

**解题思路**

- 如果糖果种类大于糖果总数的一半了，返回糖果数量的一半 **因为妹妹已经得到种类最多的糖果了** 
-  **否则，就是返回 糖果的种类。** 

```java
    public int distributeCandies(int[] candies) {
        HashSet<Integer> set = new HashSet<Integer>();
		for (int candy : candies) {
			set.add(candy);
		}
		return Math.min(set.size(), candies.length / 2);
    }
```

### [1816. 截断句子](https://leetcode-cn.com/problems/truncate-sentence/)

 **句子** 是一个单词列表，列表中的单词之间用单个空格隔开，且不存在前导或尾随空格。每个单词仅由大小写英文字母组成（不含标点符号）。 

- 例如，`"Hello World"`、`"HELLO"` 和 `"hello world hello world"` 都是句子。

- 给你一个句子 s 和一个整数 k ，请你将 s 截断 ，使截断后的句子仅含 前 k 个单词。返回 截断 s 后得到的句子。

   **示例 1：** 

```
输入：s = "Hello how are you Contestant", k = 4
输出："Hello how are you"
解释：
s 中的单词为 ["Hello", "how" "are", "you", "Contestant"]
前 4 个单词为 ["Hello", "how", "are", "you"]
因此，应当返回 "Hello how are you"
```

 **示例 2：** 

```
输入：s = "What is the solution to this problem", k = 4
输出："What is the solution"
解释：
s 中的单词为 ["What", "is" "the", "solution", "to", "this", "problem"]
前 4 个单词为 ["What", "is", "the", "solution"]
因此，应当返回 "What is the solution"
```

 **示例 3：** 

```
输入：s = "chopper is not a tanuki", k = 5
输出："chopper is not a tanuki"
```

**解题思路**

- 根据空格进行分割、然后转为List 取前k个数据
- 将List转为String输出

```java
	public String truncateSentence(String str, int k) {
		//将字符串空格分隔、然后取前几个
		String[] asArray = str.split(" ");
		List<String> stringList = Arrays.asList(asArray);
		String result = String.join(" ", stringList.subList(0, k));
		return result;
	}
```



方法二：

- charAt 等于空格时候则cnt++
- 当k等于cnt的时候则跳出循环拼接字符串输出

```java
    public String truncateSentence(String s, int k) {
        int cnt = 0;
		StringBuffer ans = new StringBuffer();
		for(int i = 0 ; i < s.length() ; i++) {
			if(s.charAt(i) == ' ') {
				cnt++;
			}
			if(cnt == k) {
				break;
			}
			ans.append(s.charAt(i));
		}
        return ans.toString();   
    }
```

### [524. 通过删除字母匹配到字典里最长单词](https://leetcode-cn.com/problems/longest-word-in-dictionary-through-deleting/)

给定一个字符串和一个字符串字典，找到字典里面最长的字符串，该字符串可以通过删除给定字符串的某些字符来得到。如果答案不止一个，返回长度最长且字典顺序最小的字符串。如果答案不存在，则返回空字符串。

 **示例 1:** 

```
输入:
s = "abpcplea", d = ["ale","apple","monkey","plea"]

输出: 
"apple"
```

 **示例 2:** 

```
输入:
s = "abpcplea", d = ["a","b","c"]

输出: 
"a"
```

**解题思路**

-  使用 `indexOf` 方法，判断从指定下标起，是否存在字符 c。不存在，则 t 不是为 s 的子序列。 

```java

	public String findLongestWord(String s, List<String> d) {
		String result = "";
		for (String t : d) {
			if (isSubsequence(t, s)) {
				// 获取长度最长且字典顺序最小的字符串
				if (result.length() < t.length() || (result.length() == t.length() && result.compareTo(t) > 0)) {
					result = t;
				}
			}
		}
		return result;
	}

	// 判断 t 是否为 s 的子序列
	public boolean isSubsequence(String t, String s) {
		int index = -1;
		for (int i = 0; i < t.length(); i++) {
			index = s.indexOf(t.charAt(i), index + 1);
			if (index == -1) {
				return false;
			}
		}
		return true;
	}
```

### [273. 整数转换英文表示](https://leetcode-cn.com/problems/integer-to-english-words/)

 将非负整数 `num` 转换为其对应的英文表示。 

 **示例 1：** 

```
输入：num = 123
输出："One Hundred Twenty Three"
```

 **示例 2：** 

```
输入：num = 12345
输出："Twelve Thousand Three Hundred Forty Five"
```

**解题思路**

-  1,234,567,890  它的英文表示为 `1 Billion 234 Million 567 Thousand 890` 
-  这样我们就将原问题分解成若干个三位整数转换为英文表示的问题了。 



```java
public String numberToWords(int num) {
		if(num == 0) return "Zero";

		StringBuilder sb = new StringBuilder();
		int index = 0;
		while(num > 0) {
			if(num % 1000 != 0) {
				StringBuilder tmp = new StringBuilder();
				helper(num % 1000, tmp);
				sb.insert(0, tmp.append(THOUSAND[index]).append(" "));
			}
			index++;
			num /= 1000;
		}
		return sb.toString().trim();
	}

	private void helper(int num, StringBuilder tmp) {
		if(num == 0) return;
		if(num < 20) {
			tmp.append(LESS_THAN_TWENTY[num]).append(" ");
		}else if(num < 100) {
			tmp.append(HUNDRED[num / 10]).append(" ");
			helper(num % 10, tmp);
		}else {
			tmp.append(LESS_THAN_TWENTY[num / 100]).append(" Hundred").append(" ");
			helper(num % 100, tmp);
		}
	}
```

### [1470. 重新排列数组](https://leetcode-cn.com/problems/shuffle-the-array/)

 给你一个数组 `nums` ，数组中有 `2n` 个元素，按 `[x1,x2,...,xn,y1,y2,...,yn]` 的格式排列。 

 请你将数组按 `[x1,y1,x2,y2,...,xn,yn]` 格式重新排列，返回重排后的数组。 

 **示例 1：** 

```
输入：nums = [2,5,1,3,4,7], n = 3
输出：[2,3,5,4,1,7] 
解释：由于 x1=2, x2=5, x3=1, y1=3, y2=4, y3=7 ，所以答案为 [2,3,5,4,1,7]

```

 **示例 2：** 

```
输入：nums = [1,2,3,4,4,3,2,1], n = 4
输出：[1,4,2,3,3,2,4,1]
```

 **示例 3：** 

```
输入：nums = [1,1,2,2], n = 2
输出：[1,2,1,2]
```

**解题思路**

-  开一个辅助数据，交替将nums[i]和nums[n+i]加入辅助数组，最后返回辅助数组即可。 

```java
public int[] shuffle(int[] nums, int n) {
		int [] ret = new int[2*n];
		for(int i=0;i<n;i++){
			ret[i*2]=nums[i];//偶数0,2，4，6,8 .....
			ret[i*2+1]= nums[n+i];//奇数，1,3,5,7.....
		}
		return ret;
	}
```

### [LCP 01. 猜数字](https://leetcode-cn.com/problems/guess-numbers/)

小A 和 小B 在玩猜数字。小B 每次从 1, 2, 3 中随机选择一个，小A 每次也从 1, 2, 3 中选择一个猜。他们一共进行三次这个游戏，请返回 小A 猜对了几次？

输入的`guess`数组为 小A 每次的猜测，`answer`数组为 小B 每次的选择。`guess`和`answer`的长度都等于3。

  **示例 1：** 

```
输入：guess = [1,2,3], answer = [1,2,3]
输出：3
解释：小A 每次都猜对了。
```

 **示例 2：** 

```
输入：guess = [2,2,3], answer = [3,2,1]
输出：1
解释：小A 只猜对了第二次。
```

**解题思路**

- 初始化count为0
- 当猜测的数字和答案相同的时候则猜测正确`count++`
- 输出count

```java
public int game(int[] guess, int[] answer) {
		int count = 0;
		for (int i = 0;i < guess.length;i++){
			if (answer[i] == guess[i]){
				count++;
			}
		}
		return count;
	}
```

### [1108. IP 地址无效化](https://leetcode-cn.com/problems/defanging-an-ip-address/)

 给你一个有效的 [IPv4](https://baike.baidu.com/item/IPv4) 地址 `address`，返回这个 IP 地址的无效化版本。 

 所谓无效化 IP 地址，其实就是用 `"[.]"` 代替了每个 `"."`。 

 **示例 1：** 

```
输入：address = "1.1.1.1"
输出："1[.]1[.]1[.]1"
```

 **示例 2：** 

```
输入：address = "255.100.50.0"
输出："255[.]100[.]50[.]0"
```

**解题思路**

- 将`.` 替换为`[.]`即可

```java
/**
	 * 字符串替换
	 * @param address
	 * @return
	 */
	public String defangIPaddr(String address) {
		return address.replace(".", "[.]");
	}
```

### [599. 两个列表的最小索引总和](https://leetcode-cn.com/problems/minimum-index-sum-of-two-lists/)

 假设Andy和Doris想在晚餐时选择一家餐厅，并且他们都有一个表示最喜爱餐厅的列表，每个餐厅的名字用字符串表示。 

 你需要帮助他们用**最少的索引和**找出他们**共同喜爱的餐厅**。 如果答案不止一个，则输出所有答案并且不考虑顺序。 你可以假设总是存在一个答案。 

 **示例 1:** 

```
输入:
["Shogun", "Tapioca Express", "Burger King", "KFC"]
["Piatti", "The Grill at Torrey Pines", "Hungry Hunter Steakhouse", "Shogun"]
输出: ["Shogun"]
解释: 他们唯一共同喜爱的餐厅是“Shogun”。
```

 **示例 2:** 

```
输入:
["Shogun", "Tapioca Express", "Burger King", "KFC"]
["KFC", "Shogun", "Burger King"]
输出: ["Shogun"]
解释: 他们共同喜爱且具有最小索引和的餐厅是“Shogun”，它有最小的索引和1(0+1)。
```

**解题思路**

-  先将list1中的名称和对应索引位置加入Map，再遍历list2中元素 
-  遇到相同的餐厅计算索引和并判断是否是最小 
-   如果当前索引和小于最小值，则清空结果集，在将当前餐厅名加入结果集，并给最小值重新赋值； 
-  如果索引和和最小值相等，则直接加入List 

```java
public String[] findRestaurant(String[] list1, String[] list2) {
    Map<String, Integer> map = new HashMap<>();
    for (int i = 0; i < list1.length; i++) {
        map.put(list1[i], i);
    }

    List<String> list = new ArrayList<>();
    int minIndex = list1.length + list2.length;
    for (int i = 0; i < list2.length; i++) {
        if (map.containsKey(list2[i])) {
            int index = i + map.get(list2[i]);
            if(minIndex > index){
                minIndex = index;
                list.clear();
                list.add(list2[i]);
            }else if(minIndex == index){
                list.add(list2[i]);
            }

        }
    }
    return list.toArray(new String[list.size()]);
}
```

### [1295. 统计位数为偶数的数字](https://leetcode-cn.com/problems/find-numbers-with-even-number-of-digits/)

 给你一个整数数组 `nums`，请你返回其中位数为 **偶数** 的数字的个数。 

 **示例 1：** 

```
输入：nums = [12,345,2,6,7896]
输出：2
解释：
12 是 2 位数字（位数为偶数） 
345 是 3 位数字（位数为奇数）  
2 是 1 位数字（位数为奇数） 
6 是 1 位数字 位数为奇数） 
7896 是 4 位数字（位数为偶数）  
因此只有 12 和 7896 是位数为偶数的数字
```

 **示例 2：** 

```
输入：nums = [555,901,482,1771]
输出：1 
解释： 
只有 1771 是位数为偶数的数字。
```

**解题思路**

-  将int转为String，调用.length，获取int是几位数
- 然后%2==0即为偶数 

```java
public int findNumbers(int[] nums) {
	int resultNum = 0;
	for (int i = 0; i < nums.length; i++) {
		if (String.valueOf(nums[i]).length() % 2 == 0) {
			resultNum++;
		}
	}
	System.out.println(resultNum);
	return resultNum;
}
```

### [1832. 判断句子是否为全字母句](https://leetcode-cn.com/problems/check-if-the-sentence-is-pangram/)

 **全字母句** 指包含英语字母表中每个字母至少一次的句子。 

 给你一个仅由小写英文字母组成的字符串 `sentence` ，请你判断 `sentence` 是否为 **全字母句** 。 

 如果是，返回 `true` ；否则，返回 `false` 。 

 **示例 1：** 

```java
输入：sentence = "thequickbrownfoxjumpsoverthelazydog"
输出：true
解释：sentence 包含英语字母表中每个字母至少一次。
```

 **示例 2：** 

```
输入：sentence = "leetcode"
输出：false
```

**解题思路**

- 26个英文字母每个都要出现一次
- 那么若length不足26则为false
- `HashSet` 是一个不允许有重复元素的集合 、将char存入`hashSet`
- 当`HashSet`的数量等于26的时候则包含26个英文字母

```java
public boolean checkIfPangram(String sentence) {
    if(sentence.length()<26){
			return false;
	}
	HashSet<Character> set =new HashSet<>();
	for(int i=0;i<sentence.length();i++){
		set.add(sentence.charAt(i));
	}
	return set.size()==26;
}
```



### [1523. 在区间范围内统计奇数数目](https://leetcode-cn.com/problems/count-odd-numbers-in-an-interval-range/)

 给你两个非负整数 `low` 和 `high` 。请你返回 `low` 和 `high` 之间（包括二者）奇数的数目。 

 **示例 1：** 

```
输入：low = 3, high = 7
输出：3
解释：3 到 7 之间奇数数字为 [3,5,7] 。
```

 **示例 2：** 

```
输入：low = 8, high = 10
输出：1
解释：8 到 10 之间奇数数字为 [9] 
```



**解题思路**

- 查询范围内的数据 利用for循环
- 判断数据是否为奇数，是奇数则++

```java
public int countOdds(int low, int high) {
     int num = 0;
	List<Integer> list = new ArrayList<>();
	for (int i = low; i <= high; i++) {
		//奇数为
		if (i % 2 == 1) {
			num++;
			System.out.println("奇数为" + i);
			list.add(i);
		}
	}
	// Integer[] aaa = list.toArray(new Integer[list.size()]);
	System.out.println(num);
  	return num;
 }
```

**解法二**

```java
 public int countOdds(int low, int high) {
        int count = (high - low) / 2;
        if(low % 2 != 0 || high % 2 != 0){
            count = count + 1;
        }
        return count;
    }
```

### [831. 隐藏个人信息](https://leetcode-cn.com/problems/masking-personal-information/)

 **示例 1：** 

```
输入: "LeetCode@LeetCode.com"
输出: "l*****e@leetcode.com"
解释： 
所有的名称转换成小写, 第一个名称的第一个字符和最后一个字符中间由 5 个星号代替。
因此，"leetcode" -> "l*****e"。

```

 **示例 2：** 

```
输入: "AB@qq.com"
输出: "a*****b@qq.com"
解释: 
第一个名称"ab"的第一个字符和最后一个字符的中间必须有 5 个星号
因此，"ab" -> "a*****b"。

```

 **示例 3：** 

```
输入: "1(234)567-890"
输出: "***-***-7890"
解释: 
10 个数字的电话号码，那意味着所有的数字都是本地号码。
```

 **示例 4：** 

```
输入: "86-(10)12345678"
输出: "+**-***-***-5678"
解释: 
12 位数字，2 个数字是国际号码另外 10 个数字是本地号码 。
```

**解题思路**

- 先判断是邮箱还是电话
- 是邮箱则保留首位和@符号后面的内容
- 如果 str是电话号码，我们只保留 str 中的所有数字。首先将最后 10 位本地号码变成 '***-***-abcd' 的形式，
- 再判断 str 中是否有额外的国际号码。如果有，则将国际号码之前添加 '+' 号并加到本地号码的最前端。
  - `\\D` : 代表任何一个非数字字符
  - `+ `：一次或多次

```java
public String maskPII(String str) {
		if (str.length()>40){
			return  "";
		}
		int atIndex = str.indexOf('@');
		if (atIndex >= 0) { // email
			return (str.substring(0, 1) + "*****" + str.substring(atIndex - 1)).toLowerCase();
		} else {
			// phone
			String digits = str.replaceAll("\\D+", "");
			String local = "***-***-" + digits.substring(digits.length() - 4);
			if (digits.length() == 10) return local;
			String ans = "+";
			for (int i = 0; i < digits.length() - 10; ++i)
				ans += "*";
			return ans + "-" + local;
		}
	}
```

### [258. 各位相加](https://leetcode-cn.com/problems/add-digits/)

给定一个非负整数 `num`，反复将各个位上的数字相加，直到结果为一位数。 

 **示例:** 

```java
输入: 38
输出: 2 
解释: 各位相加的过程为：3 + 8 = 11, 1 + 1 = 2。 由于 2 是一位数，所以返回 2
```

**解题思路**

- 使用递归处理

```java
public int addDigits(int num) {
		if(num<10){
			return num;
		}
		while(num>=10){
			int temp = num%10;
			num=num/10;
			num=num+temp;
		}
		return num;
	}
```

### [14. 最长公共前缀](https://leetcode-cn.com/problems/longest-common-prefix/)

编写一个函数来查找字符串数组中的最长公共前缀。

如果不存在公共前缀，返回空字符串 `""`。

 **示例 1：** 

```
输入：strs = ["flower","flow","flight"]
输出："fl"
```

 **示例 2：** 

```
输入：strs = ["dog","racecar","car"]
输出：""
解释：输入不存在公共前缀。
```

**解题思路**

- 存储初始化的前缀
- 当字符串str不以res为前缀时，就对res截断最后一个字符

```java
public String longestCommonPrefix(String[] strs) {
		if(strs.length==0)  return "";
		String res=strs[0];  //用于储存最长公共前缀，初始化为strs[0]
		for(String str:strs){
			//当字符串str不以res为前缀时，就对res截断最后一个字符
			while(!str.startsWith(res)){
				res=res.substring(0,res.length()-1);
			}
		}
		return res;
	}
```



### [3. 无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)

 给定一个字符串，请你找出其中不含有重复字符的 **最长子串** 的长度。 

 **示例 1:** 

```
输入: s = "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3
```

 **示例 2:** 

```
输入: s = "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

 **示例 3:** 

```
输入: s = "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

 **示例 4:** 

```
输入: s = ""
输出: 0
```

**解题思路**

-  这道题主要用到思路是：滑动窗口 
-  其实就是一个队列,比如例题中的 `abcabcbb`，进入这个队列（**窗口**）为 `abc` 满足题目要求  当再进入 `a`，队列变成了 `abca`，这时候不满足要求。所以，我们要移动这个队列！  我们只要把队列的左边的元素移出就行了，直到满足题目要求 

```java
    public int lengthOfLongestSubstring(String s) {
        if (s.length()==0) return 0;
        HashMap<Character, Integer> map = new HashMap<Character, Integer>();
        int max = 0;
        int left = 0;
        for(int i = 0; i < s.length(); i ++){
            if(map.containsKey(s.charAt(i))){
                left = Math.max(left,map.get(s.charAt(i)) + 1);
            }
            map.put(s.charAt(i),i);
            max = Math.max(max,i-left+1);
        }
        return max;
    }
```



### [709. 转换成小写字母](https://leetcode-cn.com/problems/to-lower-case/)

 实现函数 ToLowerCase()，该函数接收一个字符串参数 str，并将该字符串中的大写字母转换成小写字母，之后返回新的字符串。 

 **示例 1：** 

```
输入: "Hello"
输出: "hello"
```

 **示例 2：** 

```
输入: "here"
输出: "here"
```

 **示例** **3：** 

```
输入: "LOVELY"
输出: "lovely"
```

**解题思路**

-  通过ASCII码表，我们知道 'A' 的十进制值是65，'a' 的十进制值是97，二者相差32，  也就是说所有的大写字母字符可以通过 += 32 转变为小写字母 

-  1.将字符串str转为字符数组 

-  2.遍历字符数组，找到大写字母，因为在ASCII码表中，所有字母都是连续的，所以根据头'A'和尾'Z'就能轻松定位了； 

-  3.将字符 += 32; 

-  4.将字符数组转回字符串类型 

  ```java
  public String toLowerCase(String str) {
  		char[] array = str.toCharArray();
  		for (int i = 0; i < array.length; i++) {
  			if (array[i] >= 'A' && array[i] <= 'Z') {
  				array[i] += 32;
  			}
  		}
  		return new String(array);
  }
  ```



### [1323. 6 和 9 组成的最大数字](https://leetcode-cn.com/problems/maximum-69-number/)

给你一个仅由数字 6 和 9 组成的正整数 `num`。

你最多只能翻转一位数字，将 6 变成 9，或者把 9 变成 6 。

 请返回你可以得到的最大数字。 

 **示例 1：** 

```
输入：num = 9669
输出：9969
解释：
改变第一位数字可以得到 6669 。
改变第二位数字可以得到 9969 。
改变第三位数字可以得到 9699 。
改变第四位数字可以得到 9666 。
其中最大的数字是 9969 。
```

 **示例 2：** 

```
输入：num = 9996
输出：9999
解释：将最后一位从 6 变到 9，其结果 9999 是最大的数。
```

 **示例 3：** 

```
输入：num = 9999
输出：9999
解释：无需改变就已经是最大的数字了。
```

**解题思路**

- 利用`StringBuffer`获取位数
- 利用`charAt`获取每位数是设么
- 将第一个出现的数据6改为9

```java
    public int maximum69Number (int num) {
		StringBuffer str=new StringBuffer(Integer.toString(num));
		for (int i = 0; i < String.valueOf(num).length(); i++) {
			if (str.charAt(i)=='6'){
				str.deleteCharAt(i);
				str.insert(i,'9');
				break;
			}
			System.out.println("数字A"+str.charAt(i));
		}
		System.out.println("返回数据"+Integer.parseInt(str.toString()));
        return Integer.parseInt(str.toString());
    }
```

方法二：

- 使用函数`replaceFirst`将第一出现的数字6替换为9既可

```java
String s = String.valueOf(num);
System.out.println(Integer.valueOf(s.replaceFirst("6", "9")));
```

### [1748. 唯一元素的和](https://leetcode-cn.com/problems/sum-of-unique-elements/)

给你一个整数数组 `nums` 。数组中唯一元素是那些只出现 **恰好一次** 的元素。

请你返回 `nums` 中唯一元素的 **和** 。

 **示例 1：** 

```
输入：nums = [1,2,3,2]
输出：4
解释：唯一元素为 [1,3] ，和为 4 。
```

 **示例 2：** 

```
输入：nums = [1,1,1,1,1]
输出：0
解释：没有唯一元素，和为 0 。
```

 **示例 3：** 

```
输入：nums = [1,2,3,4,5]
输出：15
解释：唯一元素为 [1,2,3,4,5] ，和为 15 。
```

**解题思路-todo **



### [344. 反转字符串](https://leetcode-cn.com/problems/reverse-string/)

 编写一个函数，其作用是将输入的字符串反转过来。输入字符串以字符数组 `char[]` 的形式给出。 

 不要给另外的数组分配额外的空间，你必须**[原地](https://baike.baidu.com/item/原地算法)修改输入数组**、使用 O(1) 的额外空间解决这一问题。 

 你可以假设数组中的所有字符都是 [ASCII](https://baike.baidu.com/item/ASCII) 码表中的可打印字符。 

 **示例 1：** 

```
输入：["h","e","l","l","o"]
输出：["o","l","l","e","h"]
```

 **示例 2：** 

```
输入：["H","a","n","n","a","h"]
输出：["h","a","n","n","a","H"]
```

**解题思路**

- 反转字符串
- 

```java
    public void reverseString(char[] s) {
         for (int i = 0; i < s.length / 2; i++) {
            char temp = s[i];
            s[i] = s[s.length-1-i];
            s[s.length-1-i] = temp;
        }
    }
```

### [剑指 Offer 17. 打印从1到最大的n位数](https://leetcode-cn.com/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof/)

 输入数字 `n`，按顺序打印出从 1 到最大的 n 位十进制数。比如输入 3，则打印出 1、2、3 一直到最大的 3 位数 999。 

 **示例 1:** 

```
输入: n = 1
输出: [1,2,3,4,5,6,7,8,9]
```



**解题思路**

- 取出最大值
- 将数据存到数组中然后打印



```java
    public int[] printNumbers(int n) {
        int m=(int)Math.pow(10,n);
        int[] mm=new int[m-1];
        for(int i=1;i<m;i++){
            mm[i-1]=i;
        }
        return mm;
    }
```



### [剑指 Offer 05. 替换空格](https://leetcode-cn.com/problems/ti-huan-kong-ge-lcof/)

 请实现一个函数，把字符串 `s` 中的每个空格替换成"%20"。 

 **示例 1：** 

```
输入：s = "We are happy."
输出："We%20are%20happy."
```

**解题思路**

- 创建一个新的`StringBuilder` 用来接收返回的数据
- 当字符是空的时候则替换为`%20` 反之则取字符串c



方法一：

```java
	public String replaceSpace(String s) {
		StringBuilder res = new StringBuilder();
		for (Character c : s.toCharArray()) {
			res.append(c == ' ' ? "%20" : c);
		}
		return res.toString();
	}
```

方法二

```java
String str="We are happy";
String result=str.replace(" ","%s");
```

### [面试题 01.06. 字符串压缩](https://leetcode-cn.com/problems/compress-string-lcci/)

字符串压缩。利用字符重复出现的次数，编写一种方法，实现基本的字符串压缩功能。比如，字符串aabcccccaaa会变为a2b1c5a3。若“压缩”后的字符串没有变短，则返回原先的字符串。你可以假设字符串中只包含大小写英文字母（a至z）。

 **示例1:** 

```
 输入："aabcccccaaa"
 输出："a2b1c5a3"
```

 **示例2:** 

```
 输入："abbccd"
 输出："abbccd"
 解释："abbccd"压缩后为"a1b2c2d1"，比原字符串长度更长。
```

**解题思路**

- 使用一个变量curChar记录当前字符
- 使用一个变量curCharCount记录当前字符出现的次数
- 当遇到新的字符的时候，就把curChar和curCharCount加入到结果res中，然后再对curChar和curCharCount重复赋值。
- 重复上面的重复，直到把所有的字符遍历完为止

```java
    public String compressString(String S) {
        //边界条件判断
        if (S == null || S.length() == 0)
            return S;

        StringBuilder res = new StringBuilder();
        //当前字符
        char curChar = S.charAt(0);
        //当前字符的数量
        int curCharCount = 1;
        for (int i = 1; i < S.length(); i++) {
            //如果当前字符有重复的，统计当前字符的数量
            if (S.charAt(i) == curChar) {
                curCharCount++;
                continue;
            }
            //走到这里，说明遇到了新的字符，
            //这里先把当前字符和他的数量加入到res中
            res.append(curChar).append(curCharCount);
            //然后让当前字符指向新的字符，并且数量也要
            //重新赋值为1
            curChar = S.charAt(i);
            curCharCount = 1;
        }
        //因为上面计算的时候会遗漏最后一个字符和他的数量,
        //这要添加到res中
        res.append(curChar).append(curCharCount);

        //根据题的要求，若“压缩”后的字符串没有变短，
        // 则返回原先的字符串
        return res.length() >= S.length() ? S : res.toString();
    }
```

### [3. 无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)

 给定一个字符串，请你找出其中不含有重复字符的 **最长子串** 的长度。 

 **示例 1:** 

```java
输入: s = "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
```

 **示例 2:** 

```
输入: s = "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

 **示例 3:** 

```
输入: s = "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

 **示例 4:** 

```
输入: s = ""
输出: 0
```

**解题思路**

-  滑动窗口 



- 其实就是一个队列,比如例题中的 abcabcbb，进入这个队列（窗口）为 abc 满足题目要求，当再进入 a，队列变成了 abca，这时候不满足要求。所以，我们要移动这个队列！
-  我们只要把队列的左边的元素移出就行了，直到满足题目要求！ 
-  直维持这样的队列，找出队列出现最长的长度时候，求出解！ 

```java
    public int lengthOfLongestSubstring(String s) {
        if (s.length()==0) return 0;
        HashMap<Character, Integer> map = new HashMap<Character, Integer>();
        int max = 0;
        int left = 0;
        for(int i = 0; i < s.length(); i ++){
            if(map.containsKey(s.charAt(i))){
                left = Math.max(left,map.get(s.charAt(i)) + 1);
            }
            map.put(s.charAt(i),i);
            max = Math.max(max,i-left+1);
        }
        return max;
    }

```

### [1160. 拼写单词](https://leetcode-cn.com/problems/find-words-that-can-be-formed-by-characters/)

 给你一份『词汇表』（字符串数组） `words` 和一张『字母表』（字符串） `chars`。 

 假如你可以用 `chars` 中的『字母』（字符）拼写出 `words` 中的某个『单词』（字符串），那么我们就认为你掌握了这个单词。 

 注意：每次拼写（指拼写词汇表中的一个单词）时，`chars` 中的每个字母都只能用一次。 

 返回词汇表 `words` 中你掌握的所有单词的 **长度之和**。 

 **示例 1：** 

```
输入：words = ["cat","bt","hat","tree"], chars = "atach"
输出：6
解释： 
可以形成字符串 "cat" 和 "hat"，所以答案是 3 + 3 = 6。
```

 **示例 2：** 

```
输入：words = ["hello","world","leetcode"], chars = "welldonehoneyr"
输出：10
解释：
可以形成字符串 "hello" 和 "world"，所以答案是 5 + 5 = 10。
```

 **提示：** 

```
输入：words = ["hello","world","leetcode"], chars = "welldonehoneyr"
输出：10
解释：
可以形成字符串 "hello" 和 "world"，所以答案是 5 + 5 = 10。
```



**解题思路**

- TODO



### [179. 最大数](https://leetcode-cn.com/problems/largest-number/)

 给定一组非负整数 `nums`，重新排列每个数的顺序（每个数不可拆分）使之组成一个最大的整数。 

 **注意：**输出结果可能非常大，所以你需要返回一个字符串而不是整数。 

 **示例 1：** 

```
输入：nums = [10,2]
输出："210"
```

 **示例 2：** 

```
输入：nums = [3,30,34,5,9]
输出："9534330"
```

 **示例 3：** 

```
输入：nums = [1]
输出："1"
```

 **示例 4：** 

```
输入：nums = [10]
输出："10"
```

 **提示：** 

```
1 <= nums.length <= 100
0 <= nums[i] <= 109
```



**解题思路**

- **TODO**

```java
public String largestNumber(int[] nums) {
		int n = nums.length;
		// 转换成包装类型，以便传入 Comparator 对象（此处为 lambda 表达式）
		Integer[] numsArr = new Integer[n];
		for (int i = 0; i < n; i++) {
			numsArr[i] = nums[i];
		}

		Arrays.sort(numsArr, (x, y) -> {
			long sx = 10, sy = 10;
			while (sx <= x) {
				sx *= 10;
			}
			while (sy <= y) {
				sy *= 10;
			}
			return (int) (-sy * x - y + sx * y + x);
		});

		if (numsArr[0] == 0) {
			return "0";
		}
		StringBuilder ret = new StringBuilder();
		for (int num : numsArr) {
			ret.append(num);
		}
		return ret.toString();
	}
```



### [1394. 找出数组中的幸运数](https://leetcode-cn.com/problems/find-lucky-integer-in-an-array/)

在整数数组中，如果一个整数的出现频次和它的数值大小相等，我们就称这个整数为「幸运数」。 

 给你一个整数数组 `arr`，请你从中找出并返回一个幸运数。 

- 如果数组中存在多个幸运数，只需返回 **最大** 的那个。
- 如果数组中不含幸运数，则返回 **-1** 。

 **示例 1：** 

```
输入：arr = [2,2,3,4]
输出：2
解释：数组中唯一的幸运数是 2 ，因为数值 2 的出现频次也是 2 。
```

 **示例 2：** 

```
输入：arr = [1,2,2,3,3,3]
输出：3
解释：1、2 以及 3 都是幸运数，只需要返回其中最大的 3 。
```

 **示例 3：** 

```
输入：arr = [2,2,2,3,3]
输出：-1
解释：数组中不存在幸运数。
```

 **示例 4：** 

```
输入：arr = [5]
输出：-1
```

 **示例 5：** 

```
输入：arr = [7,7,7,7,7,7,7]
输出：7
```

**解题思路**

-  利用HashMap进行统计每个元素出现的次数，
- 遍历HashMap，当key==value的时候取key的最大值。 

```java
public int findLucky(int[] arr) {
		Map<Integer,Integer> b = new HashMap<Integer,Integer>();
		for(int i : arr){
			b.put(i,b.getOrDefault(i,0)+1);
		}
		int res = -1;
		for(Map.Entry<Integer,Integer> entry:b.entrySet()){
			int key = entry.getKey();
			int value = entry.getValue();
			if(key == value){
				res = Math.max(res,key);
			}
		}
		return res;
	}
```

### [9. 回文数](https://leetcode-cn.com/problems/palindrome-number/)

 给你一个整数 `x` ，如果 `x` 是一个回文整数，返回 `true` ；否则，返回 `false` 。 

 回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。例如，`121` 是回文，而 `123` 不是。 

 **示例 1：** 

```
输入：x = 121
输出：true
```

 **示例 2：** 

```
输入：x = -121
输出：false
解释：从左向右读, 为 -121 。 从右向左读, 为 121- 。因此它不是一个回文数。
```

 **示例 3：** 

```
输入：x = 10
输出：false
解释：从右向左读, 为 01 。因此它不是一个回文数。
```

 **示例 4：** 

```
输入：x = -101
输出：false
```

**解题思路**

- 将数字转换为字符串避免溢出
- 然后进行反转字符串
- 判断反转后的字符串和数字是否相同

```java
	public boolean isPalindrome(int x) {
		String strChars=String.valueOf(x);
		String reverseStr =new StringBuilder(strChars).reverse().toString();
		if(strChars.equals(reverseStr)){
			return true;
		}
		return false;
	}
```

### [541. 反转字符串 II](https://leetcode-cn.com/problems/reverse-string-ii/)

 给定一个字符串 `s` 和一个整数 `k`，你需要对从字符串开头算起的每隔 `2k` 个字符的前 `k` 个字符进行反转。 

- 如果剩余字符少于 `k` 个，则将剩余字符全部反转。
- 如果剩余字符小于 `2k` 但大于或等于 `k` 个，则反转前 `k` 个字符，其余字符保持原样。

 **示例:** 

```
输入: s = "abcdefg", k = 2
输出: "bacdfeg"
```

**解题思路**

- 重点理解这个吧Math.min(i + k - 1, chars.length - 1))
- 比如"abcdefgh" k = 3,每隔三个反转，i=0时i + k - 1 = 2, 下一次i += 2*k = 6，即从g开始，i + k - 1 = 8 > 7
- 说明最后的元素数量小于k,要全部反转

```java
  public String reverseStr(String s, int k) {
        char[] chars = s.toCharArray();
        for (int i = 0; i < chars.length; i += (k * 2)) {
              revser(chars, i, Math.min(i + k - 1, chars.length - 1));
        }
        return new String(chars);
    }
    public void revser(char[] chars, int i, int j) {
        for (int k = i; k < j; k++) {
            char temp = chars[k];
            chars[k] = chars[j];
            chars[j] = temp;
            j--;
        }
    }
```





### [20. 有效的括号](https://leetcode-cn.com/problems/valid-parentheses/)

 给定一个只包括 `'('`，`')'`，`'{'`，`'}'`，`'['`，`']'` 的字符串 `s` ，判断字符串是否有效。 

有效字符串需满足：

1. 左括号必须用相同类型的右括号闭合。
2. 左括号必须以正确的顺序闭合。

**解题思路**

- 如果是左括号，就把他们对应的右括号压栈
- 如果栈不为空，栈顶元素就要出栈，和这个右括号比较。
- 如果栈顶元素不等于这个右括号，说明无法匹配， 直接返回 `false` 

```java
	public boolean isValid(String s) {
		if (s.length() % 2 == 1) {
			return false;
		}
		Stack<Character> stack = new Stack<>();
		char[] chars = s.toCharArray();
		//遍历所有的元素
		for (char c : chars) {
			//如果是左括号，就把他们对应的右括号压栈
			if (c == '(') {
				stack.push(')');
			} else if (c == '{') {
				stack.push('}');
			} else if (c == '[') {
				stack.push(']');
			} else if (stack.isEmpty() || stack.pop() != c) {
				//否则就只能是右括号。
				//1，如果栈为空，说明括号无法匹配。
				//2，如果栈不为空，栈顶元素就要出栈，和这个右括号比较。
				//如果栈顶元素不等于这个右括号，说明无法匹配，
				//直接返回false。
				return false;
			}
		}
		//最后如果栈为空，说明完全匹配，是有效的括号。
		//否则不完全匹配，就不是有效的括号
		return stack.isEmpty();
	}
```



### [剑指 Offer 57. 和为s的两个数字](https://leetcode-cn.com/problems/he-wei-sde-liang-ge-shu-zi-lcof/)

输入一个递增排序的数组和一个数字s，在数组中查找两个数，使得它们的和正好是s。如果有多对数字的和等于s，则输出任意一对即可。

  **示例 1：** 

```
输入：nums = [2,7,11,15], target = 9
输出：[2,7] 或者 [7,2]
```

 **示例 2：** 

```
输入：nums = [10,26,30,31,47,60], target = 40
输出：[10,30] 或者 [30,10]
```

**解题思路**

- 指针 ii 指向数组首位数字，指针 jj 指向数组末位数字。
  若两数字之和大于了 targettarget，则指针 jj 往左移一位。
  若两数字之和小于了 targettarget，则指针 ii 往右移一位。
  若两数字之和等于了 targettarget，返回结果 [i, j][i,j] 即可。

```java
    public int[] twoSum(int[] nums, int target) {
        int i = 0, j = nums.length - 1;
        while(i < j) {
            int s = nums[i] + nums[j];
            if(s < target) i++;
            else if(s > target) j--;
            else return new int[] { nums[i], nums[j] };
        }
        return new int[0];
    }

```

### [283. 移动零](https://leetcode-cn.com/problems/move-zeroes/)

 给定一个数组 `nums`，编写一个函数将所有 `0` 移动到数组的末尾，同时保持非零元素的相对顺序。 

 **示例:** 

```
输入: [0,1,0,3,12]
输出: [1,3,12,0,0]
```



**解题思路**

-  把前面的数字都赋好值之后 后面的数字就都是0了；直接循环赋值0； 



```java
	public void moveZeroes(int[] nums) {
		int index=0;
		for (int i = 0; i < nums.length; i++) {
			if(nums[i]!=0){
				nums[index]=nums[i];
				index++;
			}
		}

		for (int i = index; i<nums.length ; i++) {
			nums[i]=0;
		}
	}
```



### [剑指 Offer 03. 数组中重复的数字](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)

 找出数组中重复的数字。 

 在一个长度为 n 的数组 nums 里的所有数字都在 0～n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，  也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。 

 **示例 1：** 

```
输入：
[2, 3, 1, 0, 2, 5, 3]
输出：2 或 3 
```



**解题思路**

- 查询重复数据则先想到``HashSet` 
- 使用循环将数据存储到`HashSet`中然后判断HashSet中是否存在该元素
- 若存在则抛出

```java
	public int findRepeatNumber(int[] nums) {
		Set<Integer> dic = new HashSet<>();
		for(int num : nums) {
			if(dic.contains(num)) return num;
			dic.add(num);
		}
		return -1;
	}
```

### [961. 重复 N 次的元素](https://leetcode-cn.com/problems/n-repeated-element-in-size-2n-array/)

 在大小为 `2N` 的数组 `A` 中有 `N+1` 个不同的元素，其中有一个元素重复了 `N` 次。 

 返回重复了 `N` 次的那个元素。 

 **示例 1：** 

```
输入：[1,2,3,3]
输出：3
```

 **示例 2：** 

```
输入：[2,1,2,5,3,2]
输出：2
```

 **示例 3：** 

```
输入：[5,1,5,2,5,3,5,4]
输出：5
```

**解题思路**

-  直接计数元素的个数。利用 `HashMap` 或者数组，这里使用 `HashMap`。 
-  然后，元素数量超过 1 的就是答案。 

```java
public int repeatedNTimes(int[] A) {
    Map<Integer, Integer> count = new HashMap();
    for (int x: A) {
        count.put(x, count.getOrDefault(x, 0) + 1);
    }

    for (int k: count.keySet())
        if (count.get(k) > 1)
            return k;

    throw null;
}
```

**解法二**

- 既然是查询元素超过一的数据

- 那么可以使用HashSet查询重复的数据并输出

```java
public int findRepeatNumber(int[] nums) {
		Set<Integer> dic = new HashSet<>();
		for(int num : nums) {
			if(dic.contains(num)) {
				return num;
			}
			dic.add(num);
		}
		return -1;
	}
```

### [剑指 Offer 17. 打印从1到最大的n位数](https://leetcode-cn.com/problems/da-yin-cong-1dao-zui-da-de-nwei-shu-lcof/)

 输入数字 `n`，按顺序打印出从 1 到最大的 n 位十进制数。比如输入 3，则打印出 1、2、3 一直到最大的 3 位数 999。 

 **示例 1:** 

```
输入: n = 1
输出: [1,2,3,4,5,6,7,8,9]
```

**解题思路**

-  n 位数的最大数、那么就是10的n次方减去1的则为需要输出的值
- Math.pow(10,i);  10的i次方

- 然后将数据存到组中

```java
	public int[] printNumbers(int n) {
		int end = (int)Math.pow(10, n) - 1;
		int[] res = new int[end];
		for(int i = 0; i < end; i++)
			res[i] = i + 1;
		return res;
	}

```



### [1464. 数组中两元素的最大乘积](https://leetcode-cn.com/problems/maximum-product-of-two-elements-in-an-array/)

 给你一个整数数组 `nums`，请你选择数组的两个不同下标 `i` 和 `j`*，*使 `(nums[i]-1)*(nums[j]-1)` 取得最大值。  请你计算并返回该式的最大值。 

 **示例 1：** 

```
输入：nums = [3,4,5,2]
输出：12 
解释：如果选择下标 i=1 和 j=2（下标从 0 开始），则可以获得最大值，(nums[1]-1)*(nums[2]-1) = (4-1)*(5-1) = 3*4 = 12 。 
```

 **示例 2：** 

```
输入：nums = [1,5,4,5]
输出：16
解释：选择下标 i=1 和 j=3（下标从 0 开始），则可以获得最大值 (5-1)*(5-1) = 16 。

```

 **示例 3：** 

```
输入：nums = [3,7]
输出：12
```

**解题思路**

- 获取最大值、题解中的数字是n-1 和j-1的2个元素的乘机
- 那么可以排序后取数据 最大数据则为 n-1，反之则为n-2

```java
public int maxProduct(int[] nums) {
		//int size=nums.length;
		Arrays.sort(nums);
		return (nums[nums.length-1]-1)*(nums[nums.length-2]-1);
	}
```

**扩展**

- 倒序输出100- 0之间的数字

```java
	void arraySout() {
		int[] array = new int[100];
		for (int k = array.length - 1; k >= 0; k--) {
			System.out.println(k);
		}
	}
```

### [面试题 16.07. 最大数值](https://leetcode-cn.com/problems/maximum-lcci/)

 编写一个方法，找出两个数字`a`和`b`中最大的那一个。不得使用if-else或其他比较运算符。 

**解题思路**

- 采用求平均值法：`max(a,b) = ((a + b) + Math.abs(a - b)) / 2` 

```java
	void  getMaxNum(int a ,int b){
		long c = a;
		long d = b;
		int res = (int) ((Math.abs(c-d) + c + d)/2);
		System.out.println(res);
	}
```



### [1796. 字符串中第二大的数字](https://leetcode-cn.com/problems/second-largest-digit-in-a-string/)

 给你一个混合字符串 `s` ，请你返回 `s` 中 **第二大** 的数字，如果不存在第二大的数字，请你返回 `-1` 。 

 **混合字符串** 由小写英文字母和数字组成。 

 **示例 1：** 

```
输入：s = "dfa12321afd"
输出：2
解释：出现在 s 中的数字包括 [1, 2, 3] 。第二大的数字是 2 。
```

 **示例 2：** 

```
输入：s = "abc1111"
输出：-1
解释：出现在 s 中的数字只包含 [1] 。没有第二大的数字。
```

**解题思路**

- 使用正则获取字符串中的数字
- 将字符串中的数字进行排序
- 取数据中的第二大数据

```java
    public int secondHighest(String s) {
        int len = s.length();
        Set<Integer> set = new HashSet<>();// 利用set的特点；
        for(int i=0;i<len;i++){
            if(s.charAt(i)>='0'&&s.charAt(i)<='9'){
                set.add(s.charAt(i)-'0');
            }
        }
        Integer[] num = new Integer[set.size()];
        set.toArray(num);
        Arrays.sort(num);
        return num.length>1?num[num.length-2]:-1;
    }
```



**扩展**

- 使用正则获取字符串中的数字

```java
	@Test
	void getNumberByStr() {
		String line = "This is getNumberByStr QT123 Or QA12354";
		// 这里的 \\D 等同于 [^0-9]
		String regEx = "\\D";
		//String regEx = "[^0-9]";
		// 把非0 - 9 的值替换为空字符串
		String s = line.replaceAll(regEx, "");
		System.out.println(s);
		// 结果 2343000
	}
```

### [1304. 和为零的N个唯一整数](https://leetcode-cn.com/problems/find-n-unique-integers-sum-up-to-zero/)

 给你一个整数 `n`，请你返回 **任意** 一个由 `n` 个 **各不相同** 的整数组成的数组，并且这 `n` 个数相加和为 `0` 。 

 **示例 1：** 

```
输入：n = 5
输出：[-7,-1,1,3,4]
解释：这些数组也是正确的 [-5,-1,1,2,3]，[-3,-1,2,-2,4]。
```

 **示例 2：** 

```
输入：n = 3
输出：[-1,0,1]
```

 **示例 3：** 

```
输入：n = 1
输出：[0]
```

**解题思路**

- 和为0 那么则有一半的数据为正数、一半的数据为负数
- 将数组的个数/2将数据化分为正数和负数

```java
	public int[] sumZero(int n) {
		int[] ans = new int[n];
		int index = 0;
		for (int i = 1; i <= n / 2; i++) {
			ans[index++] = -i;
			ans[index++] = i;
		}
		return ans;
	}
```



### [389. 找不同](https://leetcode-cn.com/problems/find-the-difference/)

 给定两个字符串 ***s*** 和 ***t***，它们只包含小写字母 

 字符串 ***t\*** 由字符串 ***s\*** 随机重排，然后在随机位置添加一个字母。 

 请找出在 ***t*** 中被添加的字母。 

 **示例 1：** 

```
输入：s = "abcd", t = "abcde"
输出："e"
解释：'e' 是那个被添加的字母。
```

 **示例 2：** 

```
输入：s = "", t = "y"
输出："y"
```

 **示例 3：** 

```
输入：s = "a", t = "aa"
输出："a"
```

 **示例 4：** 

```
输入：s = "ae", t = "aea"
输出："a"
```



**解题思路**

```java
    public char findTheDifference(String s, String t) {
        char ans = t.charAt(t.length()-1);
        for(int i = 0; i < s.length(); i++) {
            ans ^= s.charAt(i);
            ans ^= t.charAt(i);
        }
        return ans;
    }
```



### [884. 两句话中的不常见单词](https://leetcode-cn.com/problems/uncommon-words-from-two-sentences/)





### [1185. 一周中的第几天](https://leetcode-cn.com/problems/day-of-the-week/)

 给你一个日期，请你设计一个算法来判断它是对应一周中的哪一天。 

 输入为三个整数：`day`、`month` 和 `year`，分别表示日、月、年。 

您返回的结果必须是这几个值中的一个 {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}。

 **示例 1：** 

```
输入：day = 31, month = 8, year = 2019
输出："Saturday"
```

 **示例 2：** 

```
输入：day = 18, month = 7, year = 1999
输出："Sunday"
```

 **示例 3：** 

```
输入：day = 15, month = 8, year = 1993
输出："Sunday"
```

**解题思路**

- 将年月日转为时间
- 根据时间获取dayweek

方法一：

```java
public String dayOfTheWeek(int day, int month, int year) {
		String dateStr = String.format("%s-%s-%s", year, month, day);
		String data[] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
		int intWeek = getDayofweek("2019-08-31");
		return data[intWeek - 1];
	}

    /**
	 * 判断某个日期是周几
	 * @param date
	 * @return
	 */
	public  int getDayofweek(String date){
		Calendar cal = Calendar.getInstance();
//   cal.setTime(new Date(System.currentTimeMillis()));
		if (date.equals("")) {
			cal.setTime(new Date(System.currentTimeMillis()));
		}else {
			cal.setTime(new Date(getDateByStr2(date).getTime()));
		}
		return cal.get(Calendar.DAY_OF_WEEK);
	}


	public  Date getDateByStr2(String dd)
	{
		SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
		Date date;
		try {
			date = sd.parse(dd);
		} catch (ParseException e) {
			date = null;
			e.printStackTrace();
		}
		return date;
	}
```



### [剑指 Offer 50. 第一个只出现一次的字符](https://leetcode-cn.com/problems/di-yi-ge-zhi-chu-xian-yi-ci-de-zi-fu-lcof/)

 在字符串 s 中找出第一个只出现一次的字符。如果没有，返回一个单空格。 s 只包含小写字母。 

 **示例:** 

```
s = "abaccdeff"
返回 "b"

s = "" 
返回 " "
```

**解题思路**

- 记录每个字符以及出现的次数
- 按照顺序遍历字符串、并找到只出现一次的的字符串

```java
public char firstUniqChar(String s) {
		if (s == null || s.length() <= 0) {
			return ' ';
		}
		int length = s.length();
        //记录每个出现的字符 和其出现次数
		int[] letters = new int[26];
		char curChar;
		for (int i = 0; i < length; i++) {
			curChar = s.charAt(i);
			letters[curChar - 'a']++;
		}
        // 再次按顺序遍历 字符串，找到只出现一次的字符并返回
		for (int i = 0; i < length; i++) {
			curChar = s.charAt(i);
			if (letters[curChar - 'a'] == 1) {
				return curChar;
			}
		}
		return ' ';
	}
```



### [面试题 17.01. 不用加号的加法](https://leetcode-cn.com/problems/add-without-plus-lcci/)

 设计一个函数把两个数字相加。不得使用 + 或者其他算术运算符。 

 **示例:** 

```
输入: a = 1, b = 1
输出: 2
```



**解题思路**

- 使用进位解决

```java
public int add(int a, int b) {
		//当(a&b)!=0时，表示需要进位
		while((a&b)!=0){
			int tmp =a;
			//(a&b)<<1表示进位信息
			a=(a&b)<<1;
			//b^tmp表示非进位操作
			b^=tmp;
		}
		//退出while循环表示a,b之间不存在进位了，通过a^b求得结果
		return a^b;
	}
```



### [509. 斐波那契数](https://leetcode-cn.com/problems/fibonacci-number/)

 **斐波那契数**，通常用 `F(n)` 表示，形成的序列称为 **斐波那契数列** 。该数列由 `0` 和 `1` 开始，后面的每一项数字都是前面两项数字的和。也就是： 

```
F(0) = 0，F(1) = 1
F(n) = F(n - 1) + F(n - 2)，其中 n > 1
```

 给你 `n` ，请计算 `F(n)` 。 

 **示例 1：** 

```
输入：2
输出：1
解释：F(2) = F(1) + F(0) = 1 + 0 = 1
```

 **示例 2：** 

```
输入：3
输出：2
解释：F(3) = F(2) + F(1) = 1 + 1 = 2
```

 **示例 3：** 

```
输入：4
输出：3
解释：F(4) = F(3) + F(2) = 2 + 1 = 3
```

**解题思路**

- 斐波那契数列

**递归解法**

```java
   public int fib(int n) {
        return fib(n, new HashMap());
    }

    public int fib(int n, Map<Integer, Integer> map) {
        if (n < 2)
            return n;
        if (map.containsKey(n))
            return map.get(n);
        int first = fib(n - 1, map);
        int second = fib(n - 2, map);
        int res = (first + second);
        map.put(n, res);
        return res;
    }
```

**非递归解法**

```java
public int fib(int n) {
		if (n < 2) {
			return n;
		}
		int p = 0, q = 0, r = 1;
		for (int i = 2; i <= n; ++i) {
			p = q;
			q = r;
			r = p + q;
		}
		return r;
	}
```

### [面试题 01.01. 判定字符是否唯一](https://leetcode-cn.com/problems/is-unique-lcci/)

 实现一个算法，确定一个字符串 `s` 的所有字符是否全都不同。 

 **示例 1：** 

```java
输入: s = "leetcode"
输出: false 
```

 **示例 2：** 

```java
输入: s = "abc"
输出: true
```

**解题思路**

- Set含有add方法

```java
	public boolean isUnique(String astr) {
		Set<Character> set = new HashSet<Character>();
		char[] ch = astr.toCharArray();
		for(char x : ch )
			if(!set.add(x))
				return false;
		return true;
	}
```



### [1207. 独一无二的出现次数](https://leetcode-cn.com/problems/unique-number-of-occurrences/)

给你一个整数数组 `arr`，请你帮忙统计数组中每个数的出现次数。

如果每个数的出现次数都是独一无二的，就返回 `true`；否则返回 `false`。

 **示例 1：** 

```
输入：arr = [1,2,2,1,1,3]
输出：true
解释：在该数组中，1 出现了 3 次，2 出现了 2 次，3 只出现了 1 次。没有两个数的出现次数相同。

```

 **示例 2：** 

```
输入：arr = [1,2]
输出：false
```

 **示例 3：** 

```
输入：arr = [-3,0,1,-3,1,1,1,-3,10,0]
输出：true
```

**解题思路**

-  使用哈希表记录每个数字的出现次数；随后再利用新的哈希表，统计不同的出现次数的数目 

-  如果不同的出现次数的数目等于不同数字的数目，则返回 true，否则返回false。 

```java
public boolean uniqueOccurrences(int[] arr) {
		Map<Integer, Integer> occur = new HashMap<Integer, Integer>();
		for (int x : arr) {
			occur.put(x, occur.getOrDefault(x, 0) + 1);
		}
		Set<Integer> times = new HashSet<Integer>();
		for (Map.Entry<Integer, Integer> x : occur.entrySet()) {
			times.add(x.getValue());
		}
		return times.size() == occur.size();
	}
```

### [448. 找到所有数组中消失的数字](https://leetcode-cn.com/problems/find-all-numbers-disappeared-in-an-array/)

给你一个整数数组 `arr`，请你帮忙统计数组中每个数的出现次数。

如果每个数的出现次数都是独一无二的，就返回 `true`；否则返回 `false`。

 **示例 1：** 

```
输入：arr = [1,2,2,1,1,3]
输出：true
解释：在该数组中，1 出现了 3 次，2 出现了 2 次，3 只出现了 1 次。没有两个数的出现次数相同。
```

 **示例 2：** 

```
输入：arr = [1,2]
输出：false
```

 **示例 3：** 

```
输入：arr = [-3,0,1,-3,1,1,1,-3,10,0]
输出：true
```

**解题思路**

-   用一个哈希表记录数组 *nums* 中的数字，由于数字范围均在 [1,n][1,*n*] 中 

-  再利用哈希表检查 [1,n][1,*n*] 中的每一个数是否出现，从而找到缺失的数字。 

```java
    public List<Integer> findDisappearedNumbers(int[] nums) {
        int n = nums.length;
        for (int num : nums) {
            int x = (num - 1) % n;
            nums[x] += n;
        }
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < n; i++) {
            if (nums[i] <= n) {
                ret.add(i + 1);
            }
        }
        return ret;
    }
```







### [204. 计数质数](https://leetcode-cn.com/problems/count-primes/)

 统计所有小于非负整数 *`n`* 的质数的数量。 

 **示例 1：** 

```
输入：n = 10
输出：4
解释：小于 10 的质数一共有 4 个, 它们是 2, 3, 5, 7 。
```

 **示例 2：** 

```
输入：n = 0
输出：0
```

 **示例 3：** 

```
输入：n = 1
输出：0
```

**解题思路**

-  在大于 1 的自然数中，除了 1 和它本身以外不再有其他因数的自然数 
- 

```java
class Solution {
    public int countPrimes(int n) {
        int ans = 0;
        for (int i = 2; i < n; ++i) {
            ans += isPrime(i) ? 1 : 0;
        }
        return ans;
    }

    public boolean isPrime(int x) {
        for (int i = 2; i * i <= x; ++i) {
            if (x % i == 0) {
                return false;
            }
        }
        return true;
    }
}
```



### [414. 第三大的数](https://leetcode-cn.com/problems/third-maximum-number/)

 给你一个非空数组，返回此数组中 **第三大的数** 。如果不存在，则返回数组中最大的数 

 **示例 1：** 

```
输入：[3, 2, 1]
输出：1
解释：第三大的数是 1 
```

 **示例 2：** 

```
输入：[1, 2]
输出：2
解释：第三大的数不存在, 所以返回最大的数 2 。
```

 **示例 3：** 

```
输入：[2, 2, 3, 1]
输出：1
解释：注意，要求返回第三大的数，是指在所有不同数字中排第三大的数。
此例中存在两个值为 2 的数，它们都排第二。在所有不同数字中排第三大的数为 1 。
```



**解题思路**

- 
- 

```java
public int thirdMax(int[] nums) {
        Arrays.sort(nums);
        List<Integer> ans = new ArrayList<>();
        
        for(int i:nums){
            if(ans.contains(i)){
                continue;
            }
            ans.add(i);
        }

        int n = ans.size();
        if(n==1 || n==2){
            return ans.get(n-1);
        }

        return ans.get(ans.size()-3);
    }
```







## 数据库

###  [176.第二高的薪水](https://leetcode-cn.com/problems/second-highest-salary/)

编写一个 SQL 查询，获取 `Employee` 表中第二高的薪水（Salary） 。 

```shell
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```

 例如上述 `Employee` 表，SQL查询应该返回 `200` 作为第二高的薪水。如果不存在第二高的薪水，那么查询应返回 `null`。 

```sql
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

**题解思路**

- 从数据中取出最大值
- 然后排出最大值的数据、取得的数据就是第二高的数据

```sql
SELECT MAX(Salary) SecondHighestSalary
FROM Employee
WHERE Salary <> (SELECT MAX(Salary) FROM Employee)
```

### [182. 查找重复的电子邮箱](https://leetcode-cn.com/problems/duplicate-emails/)

 编写一个 SQL 查询，查找 `Person` 表中所有重复的电子邮箱。 

 **示例：** 

```
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```

 根据以上输入，你的查询应返回以下结果： 

```mysql
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```

**解题思路**

- 先进行groupBy
- 然后查询email数量大于1的数据则查询为a@b.com

```sql
select Email
from Person
group by Email
having count(Email) > 1;
```



### [58. 最后一个单词的长度](https://leetcode-cn.com/problems/length-of-last-word/)

给你一个字符串 s，由若干单词组成，单词之间用空格隔开。返回字符串中最后一个单词的长度。如果不存在最后一个单词，请返回 0 。

单词 是指仅由字母组成、不包含任何空格字符的最大子字符串。

 **示例 1：** 

```
输入：s = "Hello World"
输出：5
```

 **示例 2：** 

```
输入：s = " "
输出：0
```

**解题思路**

- 将字符串根据空格分隔 
- 获取数组中最后一位则为strArray.length - 1

```java
public int lengthOfLastWord(String str) {
		String[] strArray = str.split(" ");
		if (strArray.length > 0) {
			String a = strArray[strArray.length - 1];
			return a == "" ? 0 : a.length();
		}
		return 0;
	}
```



### [196. 删除重复的电子邮箱](https://leetcode-cn.com/problems/delete-duplicate-emails/)

 编写一个 SQL 查询，来删除 `Person` 表中所有重复的电子邮箱，重复的邮箱里只保留 **Id** *最小* 的那个。 

```sql
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id 是这个表的主键。
```

 例如，在运行你的查询语句之后，上面的 `Person` 表应返回以下几行: 

```sql
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
```

**解题思路**

方法一

- groupBy 查询出最小的id 
- 删除非最小id的数据

```mysql
delete from Person as b 
where b.Id not in(
select c.Id from (select Min(a.Id) as Id from Person  as a group by a.Email having count(a.Email)>0) as c)
```

方法二：

- 首先通过自连接生成临时表

  ```
  SELECT 
      p1.*, p2.*
  FROM
      Person p1
          JOIN
      Person p2 ON p1.Email = p2.Email
  ORDER BY p1.Id;
  ```

  ![image-20210507140247259](C:\Users\Manager\AppData\Roaming\Typora\typora-user-images\image-20210507140247259.png)

- 此时可以清楚的看到，查询临时表中符合 `p1.Id > p2.Id` 的数据即可

```mysql
DELETE p1 FROM Person p1
        JOIN
    Person p2 ON p1.Email = p2.Email 
WHERE
    p1.Id > p2.Id;
```



### [620. 有趣的电影](https://leetcode-cn.com/problems/not-boring-movies/)

某城市开了一家新的电影院，吸引了很多人过来看电影。该电影院特别注意用户体验，专门有个 LED显示板做电影推荐，上面公布着影评和相关电影描述。

作为该电影院的信息部主管，您需要编写一个 SQL查询，找出所有影片描述为非 boring (不无聊) 的并且 id 为奇数 的影片，结果请按等级 rating 排列。

 例如，下表 `cinema`: 

```shell
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
```

 对于上面的例子，则正确的输出是为： 

```shell
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   5     | House card|   Interesting|   9.1     |
|   1     | War       |   great 3D   |   8.9     |
+---------+-----------+--------------+-----------+
```



**解题思路**

- 主要是考查mysql获取奇/偶数  `MOD(ID,2)=1 `奇数 `MOD(ID,2)=0 `偶数

```mysql
SELECT * FROM cinema WHERE
description<>'boring' AND MOD(ID,2)=1 
order by rating DESC 
```

### [183. 从不订购的客户](https://leetcode-cn.com/problems/customers-who-never-order/)

 某网站包含两个表，`Customers` 表和 `Orders` 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户。  `Customers` 表： 

```
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```

 `Orders` 表： 

```
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+

```

 例如给定上述表格，你的查询应返回： 

```
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

**解题思路**

- 通过`Customers` 表中的Id关联`Orders`  中的CustomerId
- 查询出`Orders` 表中不存在的id数据

```mysql
SELECT NAME AS CUSTOMERS
FROM CUSTOMERS
WHERE ID NOT IN (SELECT CUSTOMERID
                 FROM ORDERS);
```



### [595. 大的国家](https://leetcode-cn.com/problems/big-countries/)

 这里有张 `World` 表 

```shell
+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
```

果一个国家的面积超过 300 万平方公里，或者人口超过 2500 万，那么这个国家就是大国家。

编写一个 SQL 查询，输出表中所有大国家的名称、人口和面积。

例如，根据上表，我们应该输出:

```shell
+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+
```

**解题思路**

方法一：

```mysql
SELECT 
	name,
	population,
	area   
FROM World  
WHERE 
(population>25000000 OR area>3000000)
```

方法二：

```mysql
SELECT
    name, population, area
FROM
    world
WHERE
    area > 3000000

UNION

SELECT
    name, population, area
FROM
    world
WHERE
    population > 25000000
```



### [184. 部门工资最高的员工](https://leetcode-cn.com/problems/department-highest-salary/)

 `Employee` 表包含所有员工信息，每个员工有其对应的 Id, salary 和 department Id。 

```
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```

 `Department` 表包含公司所有部门的信息。 

```
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```

 编写一个 SQL 查询，找出每个部门工资最高的员工。对于上述表，您的 SQL 查询应返回以下行（行的顺序无关紧要）。 

```shell
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```

**解题思路**

- 可以根据2个字段in查询

```mysql

SELECT
    A.name AS 'Department',
    B.name AS 'Employee',
    A.Salary
FROM
    Employee A
    INNER JOIN  Department B ON A.DepartmentId = B.Id
WHERE
    (A.DepartmentId , A.Salary) IN
    (   SELECT
           C.DepartmentId, MAX(C.Salary)
        FROM
            Employee C
        GROUP BY C.DepartmentId
	)
;
```

方法二:

- 生成临时表

```mysql
with temp as (
    select d.Name as Department, e1.Name as Employee, e1.Salary 
    from Employee e1 
        inner join Department d 
            on e1.DepartmentId = d.Id
    where not exists(
        select * from Employee e2 where e1.DepartmentId = e2.DepartmentId and e2.Salary > e1.Salary order by Salary
        )
    ) 
select * from temp;
```



