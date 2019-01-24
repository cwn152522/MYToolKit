oc、swift的一些小工具类封装(autolayout、json模型转化等)，支持cocoapods

# MYAutolayout
oc基于链式编程实现的自动布局库，简化布局代码


# MYSwiftJsonModel
swift基于codable协议封装的json-model转化库，代码量不多，大多数工作都系统做了。不同于其他模型转换库封装思想，对于同一个模型，可适用于多种json格式

使用方法：
![Image text](https://ws4.sinaimg.cn/large/006tNbRwgy1fxnkemfpo7j31ou0rc0ze.jpg)
如图，第一个参数是目标模型类，第二个参数是json字典，第三个参数是映射字典


<br><br><br><br><br><br><br><br>
接下来我们来看一个具体的例子<br><br>
模型类：需要实现codable协议
![Image text](https://ws2.sinaimg.cn/large/006tNbRwgy1fxnkiod6fij319c0asta0.jpg)

待解析json数据
![Image text](https://ws2.sinaimg.cn/large/006tNbRwgy1fxnkocojjdj31o00u0gq9.jpg)

映射字典(1.模型定义的Author，json数据里是author 2.模型嵌套了模型(且子模型名也存在不一致情况) 3.模型嵌套了模型数组)
![Image text](https://ws1.sinaimg.cn/large/006tNbRwgy1fxnkv9ni2kj31fe0emmz9.jpg)

转换结果
<br><img src='https://ws2.sinaimg.cn/large/006tNbRwgy1fxnkztn5u2j30lq0hedik.jpg' width='340' height='300'></img>
