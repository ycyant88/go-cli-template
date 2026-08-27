package cmd

import (
	"fmt"
	"runtime"

	"github.com/spf13/cobra"
)

var (
	name     = "NULL"
	version  = "DEV"
	platform = runtime.GOOS
	arch     = runtime.GOARCH
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "A brief description of your command",

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(name + " " + version + " " + platform + "/" + arch)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
