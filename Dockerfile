FROM node:22-alpine AS base

FROM base AS deps
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

FROM base AS builder
WORKDIR /app

ARG NEXT_PUBLIC_UMAMI_ENABLED
ARG NEXT_PUBLIC_UMAMI_SCRIPT_SRC
ARG NEXT_PUBLIC_UMAMI_WEBSITE_ID
ARG NEXT_PUBLIC_SITE_URL

ENV NEXT_PUBLIC_UMAMI_ENABLED=$NEXT_PUBLIC_UMAMI_ENABLED
ENV NEXT_PUBLIC_UMAMI_SCRIPT_SRC=$NEXT_PUBLIC_UMAMI_SCRIPT_SRC
ENV NEXT_PUBLIC_UMAMI_WEBSITE_ID=$NEXT_PUBLIC_UMAMI_WEBSITE_ID
ENV NEXT_PUBLIC_SITE_URL=$NEXT_PUBLIC_SITE_URL

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npm run build

FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000

CMD ["node", "server.js"]