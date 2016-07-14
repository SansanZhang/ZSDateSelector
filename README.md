# ZSDateSelector
It is a simple time selector.

You can user it to custom a time range which you need.

Aslo you can custom the date selector. 

## How to use？
1、导入头文件
   
 <pre><code> #import "ZSDateSelector.h" </code></pre>
 
2、使用，初始化并［ showDateSelector］;在初始化之后可自定义dateSeletor
<pre><code> - (void)buttonAction
{
    ZSDateSelector *seleter = [[ZSDateSelector alloc]initWithParentView:self.view.window fromDate:_formDate endDate:_endDate];
    seleter.delegate = self;
    [seleter showDateSelector];
}</code></pre>
 	
3、实现delegate回调,
<pre><code>回调之前已经实现了[ hiddenDateSelector]，所以无需在回调中再次实现
- (void)sureActionWithFromDate:(NSDate *)fromDate endDate:(NSDate *)endDate
{

}</code></pre>

## License
ZSDateSelector is published under MIT License
<pre><code>
The MIT License (MIT)

Copyright (c) 2016 SansanZhang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</code></pre>