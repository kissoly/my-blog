# 图片资源目录

这个目录用于存放博客文章中使用的图片和其他媒体文件。

## 📁 目录结构

```
images/
├── 2025/              # 按年份分类
│   ├── 01-january/   # 按月份分类
│   ├── 02-february/
│   └── ...
├── common/           # 通用图片
│   ├── icons/       # 图标文件
│   ├── logos/       # Logo文件
│   └── backgrounds/ # 背景图片
└── README.md        # 本说明文件
```

## 📋 使用规范

### 文件命名

- 使用小写字母和连字符
- 包含描述性信息
- 避免中文和特殊字符

**示例**:
```
✅ spring-boot-architecture.png
✅ java-trim-example-01.jpg
✅ github-repository-structure.svg

❌ 图片1.png
❌ Spring Boot架构.jpg
❌ image_2025_01_18.png
```

### 文件格式

- **PNG**: 截图、图表、透明背景图片
- **JPG**: 照片、复杂图像
- **SVG**: 图标、简单图形、矢量图
- **GIF**: 动画演示（谨慎使用）

### 文件大小

- 单个图片不超过 **2MB**
- 优先使用压缩后的图片
- 推荐使用在线压缩工具：
  - [TinyPNG](https://tinypng.com/)
  - [Squoosh](https://squoosh.app/)
  - [Compressor.io](https://compressor.io/)

## 🔗 引用方式

### 相对路径引用

```markdown
![图片描述](../../assets/images/2025/01-january/example.png)
```

### GitHub CDN引用

```markdown
![图片描述](https://raw.githubusercontent.com/kissoly/my-blog/main/assets/images/2025/01-january/example.png)
```

### jsDelivr CDN引用（推荐）

```markdown
![图片描述](https://cdn.jsdelivr.net/gh/kissoly/my-blog@main/assets/images/2025/01-january/example.png)
```

## 🛠️ 图片处理工具

### 在线工具

- **压缩**: TinyPNG, Squoosh
- **编辑**: Photopea, Canva
- **格式转换**: CloudConvert
- **截图**: Lightshot, Snipaste

### 本地工具

- **编辑**: GIMP, Paint.NET
- **压缩**: ImageOptim (Mac), FileOptimizer (Windows)
- **批处理**: XnConvert

## 📊 图片统计

- 📁 总文件数: 0
- 📏 总大小: 0 MB
- 📅 最后更新: 2025-01-18

## 🔄 维护任务

### 定期检查

- [ ] 清理未使用的图片
- [ ] 检查图片链接有效性
- [ ] 优化图片大小和格式
- [ ] 更新图片统计信息

### 备份策略

- 重要图片本地备份
- 定期检查CDN可用性
- 考虑使用多个图床服务

---

*保持图片资源的整洁和高效，让博客加载更快，阅读体验更好！* 🚀