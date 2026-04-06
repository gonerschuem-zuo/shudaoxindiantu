# Cloudinary 配置指南

## 获取免费账号

1. 访问：https://cloudinary.com/users/register/free
2. 注册后进入 Dashboard
3. 记录以下信息：
   - **Cloud name**：在 Dashboard 顶部
   - **Upload preset**：需要创建（见下方）

## 创建 Upload Preset（免签名上传）

1. 进入 Settings → Upload
2. 点击 "Add upload preset"
3. 配置：
   - **Preset name**: `calligraphy_upload`
   - **Signing mode**: Unsigned
   - **Folder**: `calligraphy` (可选)
4. 点击 Save

完成后，你会得到一个 **Upload preset name**（类似 `calligraphy_upload`）

## 在 index.html 中配置

找到代码中的 `CLOUDINARY_CONFIG` 部分，填入你的信息：

```javascript
const CLOUDINARY_CONFIG = {
    cloudName: '你的cloud_name',
    uploadPreset: '你的upload_preset',
    folder: 'calligraphy' // 可选
};
```

---

## 免费额度

- **存储**: 5GB
- **带宽**: 25GB/月
- **转化**: 25,000次/月

足够存储约 **10,000-50,000** 张压缩后的书法图片！
