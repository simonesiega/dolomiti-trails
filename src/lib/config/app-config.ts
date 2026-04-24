export const appConfig = {
  siteUrl: process.env.NEXT_PUBLIC_SITE_URL,

  metadata: {
    iconPath: "/icon.svg",
  },

  analytics: {
    umami: {
      enabled: process.env.NEXT_PUBLIC_UMAMI_ENABLED === "true",
      scriptSrc: process.env.NEXT_PUBLIC_UMAMI_SCRIPT_SRC,
      websiteId: process.env.NEXT_PUBLIC_UMAMI_WEBSITE_ID,
    },
  },
} as const;
