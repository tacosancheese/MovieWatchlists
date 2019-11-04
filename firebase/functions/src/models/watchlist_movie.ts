export interface WatchlistMovie {
    readonly id: number
    readonly title: string
    readonly overview: string
    readonly posterUrl: string
    readonly genres: string[]
    readonly addedBy: string
    readonly watchedBy: string[];
}