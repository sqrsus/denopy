# 构建阶段
FROM denoland/deno:alpine-1.40.0 AS builder

WORKDIR /app

COPY deps.ts .
COPY deno.json deno.lock ./

RUN deno cache deps.ts

COPY . .

# 编译成可执行文件
RUN deno compile --allow-net --allow-read --output mstv main.ts

# 运行时阶段
FROM alpine:3.18

WORKDIR /app

# 复制可执行文件
COPY --from=builder /app/mstv /app/mstv

EXPOSE 8000

CMD ["./mstv"]
