# 使用 Deno 官方镜像作为基础
FROM denoland/deno:alpine-1.40.0 AS builder

WORKDIR /app

# 复制依赖文件
COPY deps.ts .
COPY deno.json deno.lock ./

# 缓存依赖
RUN deno cache deps.ts

# 复制源代码
COPY . .

# 编译成可执行文件（可选）
RUN deno compile --allow-net --allow-read --output mstv main.ts

# 运行时阶段
FROM alpine:3.18

RUN apk add --no-cache libgcc libstdc++

WORKDIR /app

# 从构建阶段复制可执行文件
COPY --from=builder /app/mstv /app/mstv

# 或者直接复制源代码（如果不编译）
# COPY --from=builder /app /app

# 暴露端口
EXPOSE 8000

# 运行应用
CMD ["./mstv"]
