更换主题\皮肤的实现思路
    1 主题就是一整套UI方案,其包括的内容有两大类:图片和颜色
    2 对于一个主题,使用一个单独的文件夹进行保存
    3 所有主题文件夹中的内容要求名称严格一致
    4 也就是说,所有主题只有文件夹名称不同,内部文件的名称完全相同
    5 在主题文件夹中,添加一个plist文件,用于保存每个主题的颜色
    6 这样,每一个主题是一个单独的文件夹,并且其中内容的名称完全相同
    7 皮肤包设计完毕后,将其直接拖到项目而非图片库中,并选择创建folder,而非grouped

    8 给UIImage和UIColor添加分类,在所有地方使用分类方法进行图片和颜色设置
    9 在分类的方法中,首先去沙盒中取出当前皮肤key,然后找到所对应皮肤的文件夹,加载该文件夹下的plist文件和图片

    10 如果用户点击了换肤操作,只需要在换肤控件的监听方法中发出一个通知,告知需要换肤的控件更换皮肤即可

    11 程序启动时,首先检查沙盒中是否有皮肤key,如果有,那么加载该key,如果没有,那么写入默认皮肤key