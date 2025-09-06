export default {
  defaultBrowser: "Safari",
  handlers: [
    {
      browser: ({ href }) => ({
        name: "Zen",
        args: ["--new", "--args", "-P", "Job", `${href}`],
        // args: ["-P", "Job", `${href}`],
      }),
      match: ["*ycombinator*", "portal.azure.com*"],
    },
  ],
};
