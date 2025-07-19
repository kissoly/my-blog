# 我的个人博客 📝

欢迎来到我的个人博客仓库！这里记录了我的学习心得、技术分享和生活感悟。

## 📚 博客结构

```
my-blog/
├── README.md              # 项目说明
├── posts/                 # 博客文章目录
│   ├── 2025/             # 按年份分类
│   │   ├── 01-january/   # 按月份分类
│   │   ├── 02-february/
│   │   └── ...
│   └── templates/        # 文章模板
├── tools/                # 开发工具
│   ├── cleanup-old-branches.sh   # Git分支清理脚本(Bash)
│   ├── cleanup-old-branches.ps1  # Git分支清理脚本(PowerShell)
│   └── README.md         # 工具使用指南
├── assets/               # 静态资源
│   ├── images/          # 图片资源
│   ├── css/             # 样式文件
│   └── js/              # JavaScript文件
├── docs/                # 文档目录
└── config/              # 配置文件
```

## 🎯 博客主题

- 💻 **技术分享**: Java、Spring Boot、前端开发、数据库等
- 🛠️ **工具使用**: 开发工具、效率工具、最佳实践
- 📖 **学习笔记**: 读书笔记、课程总结、技术文档
- 🌱 **成长记录**: 项目经验、问题解决、思考总结
- 🎨 **创意项目**: 个人项目、开源贡献、实验性代码

## 📝 文章列表

### 2025年

#### 1月
- 🚀 [博客仓库初始化](posts/2025/01-january/blog-repository-setup.md) - 2025-01-18
- ⚡ [Java代码优化实战：列表元素类型一致性检查](posts/2025/01-january/java-code-optimization-guide.md) - 2025-01-18

*更多文章正在路上...*

## 🛠️ 开发工具

### Git分支自动清理工具

本仓库提供了一套完整的Git远程分支自动清理工具，帮助开发者维护干净的代码仓库：

- 📁 **[tools/cleanup-old-branches.sh](tools/cleanup-old-branches.sh)** - Linux/macOS Bash脚本
- 📁 **[tools/cleanup-old-branches.ps1](tools/cleanup-old-branches.ps1)** - Windows PowerShell脚本
- 📖 **[tools/README.md](tools/README.md)** - 详细使用指南

#### 🌟 主要特性
- 🕒 基于分支创建时间自动识别过期分支
- 🛡️ 内置受保护分支列表，防止误删重要分支
- 🔍 试运行模式，安全预览删除计划
- 📊 详细的统计信息和彩色日志输出
- ⚙️ 灵活的参数配置（远程仓库、天数阈值等）

#### 🚀 快速使用

```bash
# Linux/macOS
chmod +x tools/cleanup-old-branches.sh
./tools/cleanup-old-branches.sh -d 30 -f

# Windows PowerShell
.\tools\cleanup-old-branches.ps1 -Days 30 -Force
```

## 🔧 使用指南

### 写作规范

1. **文件命名**: 使用小写字母和连字符，如 `spring-boot-tutorial.md`
2. **目录结构**: 按年月分类存放，便于管理和查找
3. **文章格式**: 使用Markdown格式，包含标题、摘要、正文、标签等
4. **图片资源**: 统一存放在 `assets/images/` 目录下

### 文章模板

```markdown
# 文章标题

> 📅 发布日期: YYYY-MM-DD  
> 🏷️ 标签: tag1, tag2, tag3  
> 📖 阅读时间: X分钟

## 摘要

简要描述文章内容...

## 正文

文章正文内容...

## 总结

文章总结...

## 参考资料

- [参考链接1](url)
- [参考链接2](url)
```

## 🌟 特色功能

- ✅ **分类管理**: 按时间和主题分类
- ✅ **标签系统**: 便于文章检索
- ✅ **模板支持**: 统一的文章格式
- ✅ **资源管理**: 图片和附件统一存储
- ✅ **版本控制**: Git管理文章版本
- ✅ **开发工具**: Git分支清理等实用工具
- ✅ **开源分享**: 公开仓库，欢迎交流

## 🤝 贡献指南

欢迎提出建议和意见！

- 🐛 **发现问题**: 请提交Issue
- 💡 **改进建议**: 欢迎Pull Request
- 📧 **联系方式**: 通过GitHub Issues联系

## 📊 统计信息

- 📝 文章总数: 2
- 🛠️ 开发工具: 1套（Git分支清理工具）
- 🏷️ 标签数量: 8
- 📅 最后更新: 2025-01-19
- ⭐ 仓库星标: 欢迎Star支持！

## 📜 许可证

本博客内容采用 [MIT License](LICENSE) 许可证。

---

**感谢您的阅读！如果觉得有用，请给个⭐支持一下！** 🙏

[![GitHub stars](https://img.shields.io/github/stars/kissoly/my-blog?style=social)](https://github.com/kissoly/my-blog/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/kissoly/my-blog?style=social)](https://github.com/kissoly/my-blog/network/members)
[![GitHub issues](https://img.shields.io/github/issues/kissoly/my-blog)](https://github.com/kissoly/my-blog/issues)